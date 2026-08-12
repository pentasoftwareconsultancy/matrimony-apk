import '../../domain/models/faq_model.dart';

class FAQService {
  Future<List<FAQModel>> fetchFAQsFromApi() async {
    // Simulate network delay for API ready architecture
    await Future.delayed(const Duration(milliseconds: 600));

    final List<Map<String, dynamic>> dummyData = [
      {
        'id': '1',
        'question': '1. How do I create my profile?',
        'answer':
            'Tap Create Account, verify your mobile number using OTP, and complete your profile by adding your personal, family, education, and partner preference details.',
      },
      {
        'id': '2',
        'question': '2. Is my personal information secure?',
        'answer':
            'Yes. Your information is protected using industry-standard security measures. You control what details are visible to other members through your privacy settings.',
      },
      {
        'id': '3',
        'question': '3. How do I upload or change my profile photo?',
        'answer':
            'Open Profile → Manage Photos, upload a new photo or replace an existing one. Photos are reviewed to ensure they meet community guidelines.',
      },
      {
        'id': '4',
        'question': '4. How do I send an interest request?',
        'answer':
            'Open a member\'s profile and tap Express Interest. If they accept your request, you can start communicating.',
      },
      {
        'id': '5',
        'question': '5. Can I chat before my interest request is accepted?',
        'answer':
            'No. Messaging is available only after the interest request has been accepted unless premium features allow otherwise.',
      },
    ];

    return dummyData.map((item) => FAQModel.fromJson(item)).toList();
  }
}
