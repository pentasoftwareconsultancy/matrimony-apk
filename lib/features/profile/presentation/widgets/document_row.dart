import 'package:flutter/material.dart';
import '../../domain/models/document_model.dart';

class DocumentRow extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onTap;
  final bool isLast;

  const DocumentRow({
    super.key,
    required this.document,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = document.status.toLowerCase() == 'verified';
    final isPending = document.status.toLowerCase() == 'pending';
    final isRejected = document.status.toLowerCase() == 'rejected';

    Color statusBgColor = const Color(0xFFE8F5E9); // Light green
    Color statusTextColor = const Color(0xFF2E7D32); // Dark green

    if (isPending) {
      statusBgColor = const Color(0xFFFFF3E0);
      statusTextColor = const Color(0xFFE65100);
    } else if (isRejected) {
      statusBgColor = const Color(0xFFFFEBEE);
      statusTextColor = const Color(0xFFC62828);
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                ),
        ),
        child: Row(
          children: [
            // Checkmark or status icon inside circle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isVerified
                    ? const Color(0xFFE8F5E9)
                    : (isPending ? const Color(0xFFFFF3E0) : const Color(0xFFFFEBEE)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isVerified
                    ? Icons.check
                    : (isPending ? Icons.hourglass_empty : Icons.close),
                color: statusTextColor,
                size: 14,
              ),
            ),
            const SizedBox(width: 12),

            // Document Title
            Expanded(
              child: Text(
                document.title,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Status Pill Badge (VERIFIED / PENDING / REJECTED) matching reference
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                document.status.toUpperCase(),
                style: TextStyle(
                  color: statusTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
