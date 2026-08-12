import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final int score; // 0: Empty, 1: Weak, 2: Medium, 3: Strong

  const PasswordStrengthMeter({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    Color getBarColor(int barIndex) {
      if (score == 0) return const Color(0xFFE5E7EB);

      if (score == 1) {
        return barIndex == 0 ? const Color(0xFFC2003B) : const Color(0xFFE5E7EB);
      } else if (score == 2) {
        return barIndex <= 1 ? const Color(0xFFF97316) : const Color(0xFFE5E7EB);
      } else {
        return const Color(0xFF10B981);
      }
    }

    String getSubtitleText() {
      if (score <= 1) {
        return 'Weak password, must contain';
      } else if (score == 2) {
        return 'Medium password, must contain';
      } else {
        return 'Strong password!';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3 Horizontal Bars
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 2 ? 8.0 : 0.0,
                ),
                decoration: BoxDecoration(
                  color: getBarColor(index),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),

        // Subtitle Text
        Text(
          getSubtitleText(),
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
