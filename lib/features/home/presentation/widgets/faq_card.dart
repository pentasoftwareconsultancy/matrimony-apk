import 'package:flutter/material.dart';
import '../../domain/models/faq_model.dart';

class FaqCard extends StatelessWidget {
  final FAQModel faq;

  const FaqCard({
    super.key,
    required this.faq,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'FAQ item: ${faq.question}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Title (e.g., "1. How do I create my profile?")
            Text(
              faq.question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            // Rounded White Container Card with Ink Ripple
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Touch feedback ripple as per guidelines
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 18.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        faq.answer,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8E8E93),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
