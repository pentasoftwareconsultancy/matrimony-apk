import 'package:flutter/material.dart';

class ProfileFieldRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;
  final bool isSpecialFormat;

  const ProfileFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
    this.isSpecialFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0x0DC9003F),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF2F2F2),
                    width: 1.0,
                  ),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Field Label (LEFT)
            SizedBox(
              width: 130,
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Field Value (RIGHT)
            Expanded(
              child: Text(
                value.isNotEmpty ? value : 'Not Specified',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: value.isNotEmpty
                      ? (isSpecialFormat ? const Color(0xFF1E1E1E) : const Color(0xFF222222))
                      : Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
