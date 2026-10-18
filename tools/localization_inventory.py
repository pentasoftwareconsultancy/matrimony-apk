#!/usr/bin/env python3
"""Safe localization inventory helper for a Flutter project.

Run from the Flutter project root:
    python tools/localization_inventory.py

It scans Dart files and writes a CSV inventory plus an English ARB draft.
It does NOT modify Dart files or existing ARB files. Review results before merging.
"""
from __future__ import annotations
import argparse
import csv
import json
import re
from pathlib import Path
from collections import OrderedDict

PATTERNS = [
    ("Text/TextSpan", re.compile(r"\b(?:Text|TextSpan)\s*\(\s*(['\"])(.*?)\1", re.S)),
    ("hintText", re.compile(r"\bhintText\s*:\s*(['\"])(.*?)\1", re.S)),
    ("labelText", re.compile(r"\blabelText\s*:\s*(['\"])(.*?)\1", re.S)),
    ("helperText", re.compile(r"\bhelperText\s*:\s*(['\"])(.*?)\1", re.S)),
    ("tooltip", re.compile(r"\btooltip\s*:\s*(['\"])(.*?)\1", re.S)),
    ("validator return", re.compile(r"\breturn\s+(['\"])(.*?)\1\s*;", re.S)),
    ("errorText", re.compile(r"\berrorText\s*:\s*(['\"])(.*?)\1", re.S)),
]
EXCLUDE_PREFIXES = ("assets/", "http://", "https://", "package:", "/", "./", "../")
EXCLUDE_EXACT = {"", " ", "\n", "\t", "G", "@", "."}
EXCLUDE_CODE = {"GET", "POST", "PUT", "DELETE", "PATCH", "application/json"}

def decode_literal(s: str) -> str:
    return s.replace(r"\n", "\n").replace(r"\t", "\t").replace(r"\'", "'").replace(r'\"', '"').replace(r"\\", "\\")

def candidate(s: str) -> bool:
    s = decode_literal(s).strip()
    if s in EXCLUDE_EXACT or s in EXCLUDE_CODE or s.startswith(EXCLUDE_PREFIXES):
        return False
    if len(s) < 2 or re.fullmatch(r"\d+([.,]\d+)?", s):
        return False
    if re.fullmatch(r"[\w./\\:-]+", s) and ("/" in s or "\\" in s):
        return False
    return bool(re.search(r"[A-Za-z]", s))

def key_for(s: str, used: set[str]) -> str:
    parts = re.findall(r"[A-Za-z0-9]+", s)
    base = "".join(p[:1].upper() + p[1:] for p in parts) or "text"
    base = base[0].lower() + base[1:]
    if base[0].isdigit():
        base = "text" + base
    key, n = base, 2
    while key in used:
        key, n = f"{base}{n}", n + 1
    used.add(key)
    return key

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lib-dir", default="lib")
    parser.add_argument("--out-dir", default="localization_review")
    args = parser.parse_args()
    root = Path.cwd()
    lib_dir = root / args.lib_dir
    out_dir = root / args.out_dir
    if not lib_dir.is_dir():
        print(f"ERROR: {lib_dir} was not found. Run from your Flutter project root.")
        return 2
    out_dir.mkdir(parents=True, exist_ok=True)
    rows, seen = [], set()
    for file in sorted(lib_dir.rglob("*.dart")):
        if file.name.startswith("app_localizations"):
            continue
        try:
            source = file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        for context, pattern in PATTERNS:
            for m in pattern.finditer(source):
                value = decode_literal(m.group(2)).strip()
                if not candidate(value):
                    continue
                line = source.count("\n", 0, m.start()) + 1
                rel = file.relative_to(root).as_posix()
                ident = (rel, line, context, value)
                if ident in seen:
                    continue
                seen.add(ident)
                rows.append({"file": rel, "line": line, "context": context,
                             "english_text": value,
                             "review_status": "REVIEW: confirm user-facing text"})
    used, text_to_key = set(), OrderedDict()
    for row in rows:
        value = row["english_text"]
        if value not in text_to_key:
            text_to_key[value] = key_for(value, used)
        row["suggested_key"] = text_to_key[value]
    csv_path = out_dir / "string_inventory.csv"
    with csv_path.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=[
            "file", "line", "context", "suggested_key", "english_text", "review_status"])
        writer.writeheader()
        writer.writerows(rows)
    arb = OrderedDict()
    arb["@@locale"] = "en"
    arb["@@comment"] = ("Draft only. Review strings and merge keys manually into "
                        "lib/l10n/app_en.arb. Do not overwrite existing keys.")
    for value, key in text_to_key.items():
        arb[key] = value
    arb_path = out_dir / "app_en.draft.arb"
    arb_path.write_text(json.dumps(arb, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Scanned: {lib_dir}")
    print(f"Candidate occurrences: {len(rows)}")
    print(f"Unique candidate strings: {len(text_to_key)}")
    print(f"CSV report: {csv_path}")
    print(f"English ARB draft: {arb_path}")
    print("No Dart files or existing ARB files were changed.")
    print("Review results: this scanner is intentionally approximate and may miss strings or include false positives.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
