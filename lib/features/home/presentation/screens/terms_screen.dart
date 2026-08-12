import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'Terms & Conditions',
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
              'Please read these terms carefully. By creating a profile on Soyarik.com, you agree to be bound by these conditions.',
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
                  _buildTermSection(
                    '1. Acceptance of Terms',
                    'By registering on Soyarik.com, you confirm that you are at least 18 years of age and legally eligible for marriage under the laws of India.\n\nThese Terms & Conditions constitute a legally binding agreement between you ("User") and Soyarik.com ("Platform"). Your continued use of the Platform constitutes acceptance of these terms in full.',
                  ),
                  _buildTermSection(
                    '2. Eligibility & Account Registration',
                    'You must provide accurate, current, and complete information during registration. Providing false information, including age, marital status, or identity details, is a violation of these terms and may lead to immediate account termination.\n\nEach user may maintain only one active account. Creating multiple accounts or accounts on behalf of another person without their consent is prohibited.\n\nYou are responsible for maintaining the confidentiality of your credentials and for all activities that occur under your account.',
                  ),
                  _buildTermSection(
                    '3. Profile Content & Conduct',
                    'All profile photos and information you upload must be genuine and current. Obscene, offensive, or misleading content is strictly forbidden.\n\nYou agree not to harass, stalk, threaten, or cause distress to any other member. Soyarik.com reserves the right to remove any content that violates community standards without prior notice.\n\nThe Platform is solely for matrimonial purposes. Using it for commercial solicitation, spam, or any purpose other than finding a life partner is prohibited.',
                  ),
                  _buildTermSection(
                    '4. Privacy & Data Use',
                    'Your personal data, including name, contact details, and identity documents (Aadhaar), is collected and processed in accordance with our Privacy Policy.\n\nProfile information is shared only with registered members of the opposite preference category. We do not sell your personal data to third parties.',
                  ),
                  _buildTermSection(
                    '5. Subscription & Payments',
                    'Certain features (Premium membership, priority listing) require a paid subscription. All payments are non-refundable unless explicitly stated otherwise.\n\nSoyarik.com reserves the right to modify pricing at any time. Existing subscribers will be notified 30 days before any price change takes effect.',
                  ),
                  _buildTermSection(
                    '6. Limitation of Liability',
                    'Soyarik.com is a platform for connecting prospective partners and does not guarantee any particular outcome, including marriage. We are not responsible for the conduct of any user, online or offline.\n\nThe Platform is provided "as is" without warranties of any kind. To the maximum extent permitted by law, Soyarik.com shall not be liable for any indirect, incidental, or consequential damages.',
                  ),
                  _buildTermSection(
                    '7. Termination',
                    'You may deactivate your account at any time from the Profile settings. Soyarik.com may suspend or terminate accounts that violate these Terms, engage in fraudulent activity, or receive repeated verified complaints from other users.\n\nUpon termination, your profile data will be archived for 90 days before permanent deletion, in compliance with applicable Indian data protection regulations.',
                  ),
                  _buildTermSection(
                    '8. Governing Law',
                    'These Terms are governed by and construed in accordance with the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts of Pune, Maharashtra.\n\nFor any queries regarding these Terms, please contact us at legal@soyarik.com.',
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

  Widget _buildTermSection(String title, String content) {
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
