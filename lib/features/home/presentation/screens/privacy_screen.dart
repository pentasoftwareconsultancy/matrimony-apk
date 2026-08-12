import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Top Red Alert Banner
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: const Text(
              'We are committed to protecting your personal data. This policy explains what information we collect, how we use it, and your rights under Indian data protection law.',
              style: TextStyle(color: Colors.white, fontSize: 11, height: 1.4),
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacySection(
                    '1. Information We Collect',
                    'Identity information: Full name, date of birth, gender, religion, and Aadhaar card number — collected during registration to verify your identity and eligibility.\n\nContact information: Phone number and email address — used to send OTPs, account alerts, and match notifications.\n\nProfile information: Occupation, income, education, family details, and photographs — displayed to potential matches based on your privacy settings.\n\nDocument Uploads: Aadhaar card images — stored securely and used solely for identity verification. These are never shared with other users.',
                  ),
                  _buildPrivacySection(
                    '2. How We Use Your Information',
                    'To create and display your matrimonial profile to eligible registered users.\n\nTo verify your identity and prevent fraudulent accounts.\n\nTo personalise match recommendations using our matching algorithm based on religion, location, profession, and stated preferences.\n\nTo send transactional communications (OTP, account alerts) and, with your consent, promotional messages about premium features.\n\nTo comply with legal obligations under Indian law, including requests from law enforcement agencies.',
                  ),
                  _buildPrivacySection(
                    '3. Data Sharing',
                    'Your profile details (name, age, profession, location, photos) are visible to other registered members.\n\nContact details (phone, email) are shared only after both parties mutually express interest.\n\nWe engage trusted third-party service providers for hosting, payment processing, and analytics. These partners are contractually bound to process data only as directed by Soyarik.com.\n\nWe do not sell, rent, or trade your personal information with advertisers or unrelated third parties.',
                  ),
                  _buildPrivacySection(
                    '4. Aadhaar & Identity Documents',
                    'Aadhaar card data is processed in compliance with the Aadhaar (Targeted Delivery) Act, 2016. We store only a masked version (last 4 digits visible) once verification is complete.\n\nRaw Aadhaar document images are encrypted at rest using AES-256 and are accessible only to authorised verification personnel.',
                  ),
                  _buildPrivacySection(
                    '5. Cookies & Tracking',
                    'We use essential cookies to keep you logged in and remember your preferences. Analytical cookies (anonymised) help us understand how users navigate the Platform so we can improve it.\n\nYou can control cookie preferences from your browser settings. Disabling essential cookies may affect Platform functionality.',
                  ),
                  _buildPrivacySection(
                    '6. Data Retention',
                    'Active profiles are retained as long as your account is active. If you deactivate your account, your details are archived for 90 days before permanent deletion.\n\nCertain transactional records may be retained for up to 7 years to comply with financial regulations.',
                  ),
                  _buildPrivacySection(
                    '7. Your Rights',
                    'You have the right to access, correct, or delete your personal information at any time through the Profile settings or by contacting privacy@soyarik.com.\n\nYou may opt out of promotional communications at any time. Transactional messages cannot be opted out of while your account is active.\n\nFor Data Protection Officer inquiries: dpo@soyarik.com | Soyarik.com, 5th Floor, Koregaon Park, Pune - 411001, Maharashtra, India.',
                  ),
                  _buildPrivacySection(
                    '8. Security',
                    'We implement industry-standard technical and organisational measures — including TLS encryption, firewalled servers, and regular penetration testing — to protect your data.\n\nDespite these measures, no internet transmission is 100% secure. We encourage you to use a strong, unique password and to report any suspected security breach to security@soyarik.com immediately.',
                  ),
                  _buildPrivacySection(
                    '9. Changes to this Policy',
                    'We may update this Privacy Policy periodically. Material changes will be notified via in-app alert and email at least 15 days before they take effect.\n\nYour continued use of the Platform after changes take effect constitutes acceptance of the revised policy.',
                  ),
                  const SizedBox(height: 12),
                  
                  // Bottom Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red.shade100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'By using Soyarik.com you confirm you have read and agree to these terms. For questions, contact',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 10, height: 1.4),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'support@soyarik.com',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Sticky Bottom Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'I Understand & Accept',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
