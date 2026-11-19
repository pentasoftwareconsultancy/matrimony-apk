import 'package:flutter/material.dart';
import '../../../../core/utils/dropdown_localizer.dart';

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

  String _localizeLabel(BuildContext context, String rawLabel) {
    if (Localizations.localeOf(context).languageCode != 'mr') {
      return rawLabel.toUpperCase();
    }
    final key = rawLabel.trim().toUpperCase();
    final map = {
      'NAME': 'नाव',
      'FULL NAME': 'पूर्ण नाव',
      'AGE': 'वय',
      'BIRTH DATE': 'जन्मतारीख',
      'DATE OF BIRTH': 'जन्मतारीख',
      'WORK PLACE': 'कामाचे ठिकाण',
      'HOME PLACE': 'घरचे ठिकाण',
      'MARITAL STATUS': 'वैवाहिक स्थिती',
      'INCOME': 'उत्पन्न',
      'ANNUAL INCOME': 'वार्षिक उत्पन्न',
      'VILLAGE': 'गाव',
      'STATE': 'राज्य',
      'PINCODE': 'पिनकोड',
      'OCCUPATION': 'व्यवसाय',
      'PROFESSION': 'व्यवसाय',
      'SUB CASTE': 'पोटजात',
      'SUB-CASTE': 'पोटजात',
      'CASTE': 'जात',
      'RELIGION': 'धर्म',
      'MOTHER TONGUE': 'मातृभाषा',
      'HEIGHT': 'उंची',
      'WEIGHT': 'वजन',
      'GENDER': 'लिंग',
      'BLOOD GROUP': 'रक्तगट',
      'DIET': 'आहार',
      'FAMILY TYPE': 'कुटुंब प्रकार',
      'FAMILY VALUES': 'कौटुंबिक मूल्ये',
      'HIGHEST EDUCATION': 'उच्च शिक्षण',
      'EMPLOYED IN': 'नोकरीचे क्षेत्र',
      'COMPANY NAME': 'कंपनीचे नाव',
      'JOB LOCATION': 'नोकरीचे स्थान',
      'COUNTRY': 'देश',
      'CITY': 'शहर',
      'DISTRICT': 'जिल्हा',
      'TALUKA': 'तालुका',
      'GOTRA': 'गोत्र',
      'RASHI': 'राशी',
      'NAKSHATRA': 'नक्षत्र',
      'CHARAN': 'चरण',
      'GAN': 'गण',
      'NADI': 'नाडी',
      'MANGLIK': 'मांगलिक',
      'PLACE OF BIRTH': 'जन्मस्थान',
      'BIRTH TIME': 'जन्म वेळ',
      'SPECIAL CASE': 'विशेष बाब',
      'PHYSICAL STATUS': 'शारीरिक स्थिती',
      'COMPLEXION': 'वर्ण (रंग)',
      'BODY TYPE': 'शरीरयष्टी',
      'AGRI. LAND': 'शेती जमीन',
      'PHONE': 'फोन',
      'EMAIL': 'ईमेल',
      "FATHER'S NAME": 'वडिलांचे नाव',
      "FATHER'S OCC.": 'वडिलांचा व्यवसाय',
      "MOTHER'S NAME": 'आईचे नाव',
      "MOTHER'S OCC.": 'आईचा व्यवसाय',
      'BROTHERS': 'भाऊ',
      'SISTERS': 'बहिणी',
    };
    return (map[key] ?? rawLabel).toUpperCase();
  }

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
                _localizeLabel(context, label),
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
                value.isNotEmpty
                    ? DropdownLocalizer.getLabel(context, value)
                    : (Localizations.localeOf(context).languageCode == 'mr' ? 'उल्लेख नाही' : 'Not Specified'),
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
