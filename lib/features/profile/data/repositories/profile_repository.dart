
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<Map<String, dynamic>> getProfileData();
  Future<Map<String, dynamic>> saveProfile(ProfileModel profile);
  Future<String> uploadPhoto(XFile file);
  Future<void> deletePhoto(String photoUrl);
  Future<Map<String, dynamic>> uploadDocumentFile(String documentId, List<int> bytes, String fileName);
  Future<Map<String, dynamic>> deleteDocument(String documentId);
}

class ApiProfileRepository implements ProfileRepository {
  final ApiClient _apiClient;

  ApiProfileRepository(this._apiClient);

  @override
  Future<ProfileModel> getProfile() async {
    final profileMap = await getProfileData();
    return ProfileModel.fromJson(profileMap);
  }

  @override
  Future<Map<String, dynamic>> getProfileData() async {
    final response = await _apiClient.get('/profile/me');
    final resData = response.data['data'] as Map<String, dynamic>;
    final profileMap = resData['profile'] as Map<String, dynamic>;
    return profileMap;
  }

  @override
  Future<Map<String, dynamic>> saveProfile(ProfileModel profile) async {
    final response = await _apiClient.put('/profile/me', data: profile.toJson());
    final resData = response.data['data'] as Map<String, dynamic>;
    final profileMap = resData['profile'] as Map<String, dynamic>;
    return profileMap;
  }

  @override
  Future<String> uploadPhoto(XFile file) async {
    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('The selected image is empty.');
    }

    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        bytes,
        filename: file.name.isNotEmpty ? file.name : 'profile_photo.jpg',
      ),
    });

    final response = await _apiClient.post(
      '/profile/photos',
      data: formData,
    );

    final responseData = response.data['data'] as Map<String, dynamic>;

    // 1. Prioritize direct photoUrl returned by backend
    final directUrl = responseData['photoUrl'] as String?;
    if (directUrl != null && directUrl.trim().isNotEmpty) {
      return directUrl.trim();
    }

    // 2. Fallback to photos list from profile payload
    final profile = responseData['profile'] as Map<String, dynamic>?;
    final photos = profile?['photos'];

    if (photos is List && photos.isNotEmpty) {
      if (photos.first is String && (photos.first as String).trim().isNotEmpty) {
        return (photos.first as String).trim();
      }
      if (photos.last is String && (photos.last as String).trim().isNotEmpty) {
        return (photos.last as String).trim();
      }
    }

    throw Exception('Upload succeeded but the saved photo URL was not returned.');
  }

  @override
  Future<void> deletePhoto(String photoUrl) async {
    await _apiClient.delete(
      '/profile/photos',
      data: {'photoUrl': photoUrl},
    );
  }

  @override
  Future<Map<String, dynamic>> uploadDocumentFile(
    String documentId,
    List<int> bytes,
    String fileName,
  ) async {
    if (bytes.isEmpty) {
      throw Exception('The selected document is empty.');
    }

    final formData = FormData.fromMap({
      'docId': documentId,
      'document': MultipartFile.fromBytes(
        bytes,
        filename: fileName.isNotEmpty ? fileName : '$documentId.pdf',
      ),
    });

    final response = await _apiClient.post(
      '/profile/documents',
      data: formData,
    );

    final resData = response.data['data'] as Map<String, dynamic>;
    return resData['profile'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> deleteDocument(String documentId) async {
    final response = await _apiClient.delete('/profile/documents/$documentId');
    final resData = response.data['data'] as Map<String, dynamic>;
    return resData['profile'] as Map<String, dynamic>;
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiProfileRepository(apiClient);
});
