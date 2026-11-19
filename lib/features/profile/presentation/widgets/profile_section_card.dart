import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  String _localizeSectionTitle(BuildContext context, String rawTitle) {
    if (Localizations.localeOf(context).languageCode != 'mr') {
      return rawTitle.toUpperCase();
    }
    final key = rawTitle.trim().toUpperCase();
    final map = {
      'PERSONAL DETAILS': 'वैयक्तिक माहिती',
      'EDUCATION & CAREER': 'शिक्षण आणि कारकीर्द',
      'RELIGIOUS & HOROSCOPE': 'धार्मिक आणि कुंडली माहिती',
      'LOCATION DETAILS': 'स्थानाचा तपशील',
      'FAMILY DETAILS': 'कुटुंबाची माहिती',
      'LIFESTYLE & HABITS': 'जीवनशैली आणि सवयी',
      'PARTNER PREFERENCES': 'जोडीदाराच्या अपेक्षा',
      'DOCUMENT DETAILS': 'दस्तऐवज तपशील',
    };
    return (map[key] ?? rawTitle).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              _localizeSectionTitle(context, title),
              style: const TextStyle(
                color: Color(0xFFC9003F), // Deep Crimson Red matching reference
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),

          // White Rounded Card Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
