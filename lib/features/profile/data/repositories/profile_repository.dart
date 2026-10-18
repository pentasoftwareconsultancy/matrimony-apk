
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
  Future<String> uploadPhoto(XFile file);
  Future<void> deletePhoto(String photoUrl);
  Future<void> uploadDocument(String documentId, String filePathOrUrl);
}

class ApiProfileRepository implements ProfileRepository {
  final ApiClient _apiClient;

  ApiProfileRepository(this._apiClient);

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _apiClient.get('/profile/me');
    final resData = response.data['data'] as Map<String, dynamic>;
    final profileMap = resData['profile'] as Map<String, dynamic>;
    return ProfileModel.fromJson(profileMap);
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await _apiClient.put('/profile/me', data: profile.toJson());
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
    final profile = responseData['profile'] as Map<String, dynamic>;

    final photos = profile['photos'];

    if (photos is List && photos.isNotEmpty && photos.last is String) {
      return photos.last as String;
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
  Future<void> uploadDocument(
      String documentId,
      String filePathOrUrl,
      ) async {
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
