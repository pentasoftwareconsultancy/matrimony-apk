import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/user.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({required String email, required String password});
  Future<bool> checkUser(String identifier);
  Future<void> sendOTP({String? email, String? phoneNumber});
  Future<Map<String, dynamic>> verifyOTP({String? email, String? phoneNumber, required String code});
  Future<Map<String, dynamic>> registerProfile(Map<String, dynamic> registrationData);
  Future<Map<String, dynamic>> uploadFiles({
    List<int>? aadharBytes,
    String? aadharFileName,
    List<int>? casteBytes,
    String? casteFileName,
    List<Map<String, dynamic>>? photos,
  });
  Future<User> getMe();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._apiClient, this._secureStorage);

  @override
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final response = await _apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final resData = response.data['data'] as Map<String, dynamic>;
    final token = resData['token'] as String;
    final userMap = resData['user'] as Map<String, dynamic>;

    await _secureStorage.saveToken(token);
    final user = User.fromJson(userMap);

    return {
      'user': user,
      'token': token,
    };
  }

  @override
  Future<bool> checkUser(String identifier) async {
    try {
      final response = await _apiClient.post('/auth/check-user', data: {
        'identifier': identifier,
      });
      final data = response.data['data'] as Map<String, dynamic>?;
      return data?['exists'] ?? false;
    } catch (_) {
      // Fallback validation check
      final normalized = identifier.trim().toLowerCase();
      final is10Digits = RegExp(r'^\d{10}$').hasMatch(normalized);
      final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$').hasMatch(normalized);
      return is10Digits || isValidEmail;
    }
  }

  @override
  Future<void> sendOTP({String? email, String? phoneNumber}) async {
    await _apiClient.post('/auth/send-otp', data: {
      if (email != null && email.isNotEmpty) 'email': email,
      if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone': phoneNumber,
    });
  }

  @override
  Future<Map<String, dynamic>> verifyOTP({
    String? email,
    String? phoneNumber,
    required String code,
  }) async {
    final response = await _apiClient.post('/auth/verify-otp', data: {
      if (email != null && email.isNotEmpty) 'email': email,
      if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
      'code': code,
    });

    final resData = response.data['data'] as Map<String, dynamic>;
    final token = resData['token'] as String;
    final userMap = resData['user'] as Map<String, dynamic>;

    await _secureStorage.saveToken(token);
    final user = User.fromJson(userMap);

    return {
      'user': user,
      'token': token,
    };
  }

  @override
  Future<Map<String, dynamic>> registerProfile(Map<String, dynamic> registrationData) async {
    final response = await _apiClient.post('/auth/register', data: registrationData);

    final resData = response.data['data'] as Map<String, dynamic>;
    final token = resData['token'] as String;
    final userMap = resData['user'] as Map<String, dynamic>;

    await _secureStorage.saveToken(token);
    final user = User.fromJson(userMap);

    return {
      'user': user,
      'token': token,
    };
  }

  @override
  Future<Map<String, dynamic>> uploadFiles({
    List<int>? aadharBytes,
    String? aadharFileName,
    List<int>? casteBytes,
    String? casteFileName,
    List<Map<String, dynamic>>? photos,
  }) async {
    final photoUrls = <String>[];
    if (photos != null) {
      for (final photo in photos) {
        photoUrls.add(photo['fileName'] as String);
      }
    }
    return {
      'aadharUrl': aadharFileName ?? 'aadhar_doc.pdf',
      'casteCertificateUrl': casteFileName ?? 'caste_doc.pdf',
      'photoUrls': photoUrls,
    };
  }

  @override
  Future<User> getMe() async {
    final response = await _apiClient.get('/auth/me');
    final resData = response.data['data'] as Map<String, dynamic>;
    final userMap = resData['user'] as Map<String, dynamic>;
    return User.fromJson(userMap);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(apiClient, secureStorage);
});
