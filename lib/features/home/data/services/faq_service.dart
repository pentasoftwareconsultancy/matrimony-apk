import '../../../../core/network/api_client.dart';
import '../../domain/models/faq_model.dart';

class FAQService {
  final ApiClient _apiClient;

  FAQService(this._apiClient);

  Future<List<FAQModel>> fetchFAQsFromApi() async {
    try {
      final response = await _apiClient.get('/faqs');
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => FAQModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
