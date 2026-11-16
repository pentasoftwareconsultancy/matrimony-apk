const List<String> _monthsList = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Safely formats any date of birth value (ISO string, MongoDB Date string, DD/MM/YYYY)
/// into a consistent, user-friendly format e.g. "14 March 1997".
///
/// Preserves the original date of birth and prevents timezone conversion shifts.
String formatDobString(dynamic raw) {
  if (raw == null) return '';
  final str = raw.toString().trim();
  if (str.isEmpty ||
      str == 'null' ||
      str == '-' ||
      str.toLowerCase() == 'not specified') {
    return '';
  }

  // Already formatted as "14 March 1997" or "1 March 1997"
  final alreadyFormatted = RegExp(r'^\d{1,2}\s+[A-Za-z]+\s+\d{4}$');
  if (alreadyFormatted.hasMatch(str)) {
    return str;
  }

  // Handle DD/MM/YYYY or DD-MM-YYYY format
  final dmyMatch =
      RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(str);
  if (dmyMatch != null) {
    final day = int.tryParse(dmyMatch.group(1)!);
    final month = int.tryParse(dmyMatch.group(2)!);
    final year = int.tryParse(dmyMatch.group(3)!);
    if (day != null &&
        month != null &&
        year != null &&
        month >= 1 &&
        month <= 12) {
      return '$day ${_monthsList[month - 1]} $year';
    }
  }

  // Handle YYYY-MM-DD format (without time)
  final ymdMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(str);
  if (ymdMatch != null && !str.contains('T')) {
    final year = int.tryParse(ymdMatch.group(1)!);
    final month = int.tryParse(ymdMatch.group(2)!);
    final day = int.tryParse(ymdMatch.group(3)!);
    if (day != null &&
        month != null &&
        year != null &&
        month >= 1 &&
        month <= 12) {
      return '$day ${_monthsList[month - 1]} $year';
    }
  }

  // Handle ISO 8601 strings (e.g. "1997-03-14T00:00:00.000Z" or "1997-03-13T18:30:00.000Z")
  try {
    final dt = DateTime.tryParse(str);
    if (dt != null) {
      DateTime effective = dt.toUtc();
      // If UTC hour >= 18 (e.g. 18:30 UTC = 00:00 IST of target day), adjust +5:30
      if (effective.hour >= 18) {
        effective = effective.add(const Duration(hours: 5, minutes: 30));
      }
      return '${effective.day} ${_monthsList[effective.month - 1]} ${effective.year}';
    }
  } catch (_) {}

  return str;
}

/// Safely parses any date representation into a UTC DateTime representing the calendar day.
DateTime? parseDobDateTime(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) {
    return DateTime.utc(raw.year, raw.month, raw.day);
  }
  final str = raw.toString().trim();
  if (str.isEmpty ||
      str == 'null' ||
      str == '-' ||
      str.toLowerCase() == 'not specified') {
    return null;
  }

  final dmyMatch =
      RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(str);
  if (dmyMatch != null) {
    final day = int.tryParse(dmyMatch.group(1)!);
    final month = int.tryParse(dmyMatch.group(2)!);
    final year = int.tryParse(dmyMatch.group(3)!);
    if (day != null && month != null && year != null) {
      return DateTime.utc(year, month, day);
    }
  }

  final ymdMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(str);
  if (ymdMatch != null && !str.contains('T')) {
    final year = int.tryParse(ymdMatch.group(1)!);
    final month = int.tryParse(ymdMatch.group(2)!);
    final day = int.tryParse(ymdMatch.group(3)!);
    if (day != null && month != null && year != null) {
      return DateTime.utc(year, month, day);
    }
  }

  try {
    final dt = DateTime.tryParse(str);
    if (dt != null) {
      var effective = dt.toUtc();
      if (effective.hour >= 18) {
        effective = effective.add(const Duration(hours: 5, minutes: 30));
      }
      return DateTime.utc(effective.year, effective.month, effective.day);
    }
  } catch (_) {}

  return null;
}

