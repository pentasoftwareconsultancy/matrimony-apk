import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/service_vendor_model.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ServiceRepository(apiClient);
});

final servicesByCategoryProvider =
    FutureProvider.family<List<ServiceVendorModel>, String>((ref, category) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getVendorsByCategory(category);
});

final vendorByIdProvider =
    FutureProvider.family<ServiceVendorModel?, String>((ref, vendorId) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getVendorById(vendorId);
});

class ServiceRepository {
  final ApiClient _apiClient;

  ServiceRepository(this._apiClient);

  Future<List<ServiceVendorModel>> getVendorsByCategory(String category) async {
    try {
      final response = await _apiClient.get('/services', queryParameters: {'category': category.toLowerCase()});
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => ServiceVendorModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<ServiceVendorModel?> getVendorById(String vendorId) async {
    try {
      final response = await _apiClient.get('/services/$vendorId');
      final data = response.data['data'] as Map<String, dynamic>;
      return ServiceVendorModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
