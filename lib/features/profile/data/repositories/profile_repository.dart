import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
  Future<String> uploadPhoto(String filePathOrUrl);
  Future<void> uploadDocument(String documentId, String filePathOrUrl);
}

class LocalProfileRepository implements ProfileRepository {
  static const String _storageKey = 'user_profile_data_v1';

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return ProfileModel.fromJson(map);
      }
    } catch (e) {
      // Fallback to default on parse error
    }
    return ProfileModel.referenceInitial();
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    // Simulate slight network delay for production-quality loading feedback
    await Future.delayed(const Duration(milliseconds: 600));
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profile.toJson());
    await prefs.setString(_storageKey, jsonStr);
  }

  @override
  Future<String> uploadPhoto(String filePathOrUrl) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // If it's already a http/https URL, return it directly, else return mock uploaded URL
    if (filePathOrUrl.startsWith('http://') || filePathOrUrl.startsWith('https://')) {
      return filePathOrUrl;
    }
    return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';
  }

  @override
  Future<void> uploadDocument(String documentId, String filePathOrUrl) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return LocalProfileRepository();
});
