import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
  Future<String> uploadPhoto(String filePathOrUrl);
  Future<void> uploadDocument(String documentId, String filePathOrUrl);
}

class ApiProfileRepository implements ProfileRepository {
  final ApiClient _apiClient;

  ApiProfileRepository(this._apiClient);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _apiClient.get('/profile/me');
      final resData = response.data['data'] as Map<String, dynamic>;
      final profileMap = resData['profile'] as Map<String, dynamic>;
      return ProfileModel.fromJson(profileMap);
    } catch (e) {
      return ProfileModel.empty();
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await _apiClient.put('/profile/me', data: profile.toJson());
  }

  @override
  Future<String> uploadPhoto(String filePathOrUrl) async {
    if (filePathOrUrl.startsWith('http://') || filePathOrUrl.startsWith('https://')) {
      return filePathOrUrl;
    }
    return filePathOrUrl;
  }

  @override
  Future<void> uploadDocument(String documentId, String filePathOrUrl) async {
    await _apiClient.put('/profile/me', data: {
      if (documentId == 'aadhar') 'aadharCardUrl': filePathOrUrl,
      if (documentId == 'caste') 'casteCertificateUrl': filePathOrUrl,
    });
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiProfileRepository(apiClient);
});
