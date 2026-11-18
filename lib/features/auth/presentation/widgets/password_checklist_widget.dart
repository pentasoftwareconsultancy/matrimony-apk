import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_helper.dart';

class PasswordChecklistWidget extends StatelessWidget {
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasMinLength;
  final bool? hasDigit;
  final bool? hasSpecialChar;

  const PasswordChecklistWidget({
    super.key,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasMinLength,
    this.hasDigit,
    this.hasSpecialChar,
  });

  Widget _buildCheckRow(String text, bool isSatisfied) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSatisfied
                  ? const Color(0xFF10B981) // Green circle
                  : const Color(0xFF9CA3AF), // Grey circle
            ),
            child: Icon(
              isSatisfied ? Icons.check : Icons.close,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: isSatisfied
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckRow(
          context.isMarathi ? 'किमान १ मोठे अक्षर' : 'At least one uppercase',
          hasUppercase,
        ),
        _buildCheckRow(
          context.isMarathi ? 'किमान १ लहान अक्षर' : 'At least one lowercase',
          hasLowercase,
        ),
        _buildCheckRow(
          context.isMarathi ? 'किमान ८ अक्षरे' : 'At least 8 characters',
          hasMinLength,
        ),
        if (hasDigit != null)
          _buildCheckRow(
            context.isMarathi ? 'किमान १ अंक' : 'At least one number',
            hasDigit!,
          ),
        if (hasSpecialChar != null)
          _buildCheckRow(
            context.isMarathi ? 'किमान १ विशेष चिन्ह' : 'At least one special character',
            hasSpecialChar!,
          ),
      ],
    );
  }
}
