import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

abstract class PasswordRepository {
  Future<void> forgotPassword({String? email, String? phoneNumber});
  Future<void> sendOTP({String? email, String? phoneNumber, required String otp});
  Future<bool> verifyOTP({String? email, String? phoneNumber, required String code});
  Future<void> resetPassword({required String newPassword, String? token});
  Future<bool> changePassword({required String currentPassword, required String newPassword});
  Future<String> getStoredPassword();
  Future<void> savePassword(String password);
  Future<String?> getStoredOTP();
  Future<void> saveOTP(String otp);
}

class PasswordRepositoryImpl implements PasswordRepository {
  final ApiClient _apiClient;
  String? _targetIdentifier;
  String? _verifiedCode;

  PasswordRepositoryImpl(this._apiClient);

  @override
  Future<void> forgotPassword({String? email, String? phoneNumber}) async {
    final identifier = (email ?? phoneNumber ?? '').trim();
    _targetIdentifier = identifier;
    await _apiClient.post('/auth/forgot-password', data: {
      'identifier': identifier,
    });
  }

  @override
  Future<void> sendOTP({String? email, String? phoneNumber, required String otp}) async {
    final identifier = (email ?? phoneNumber ?? '').trim();
    _targetIdentifier = identifier;
    await _apiClient.post('/auth/forgot-password', data: {
      'identifier': identifier,
    });
  }

  @override
  Future<bool> verifyOTP({String? email, String? phoneNumber, required String code}) async {
    final identifier = (email ?? phoneNumber ?? _targetIdentifier ?? '').trim();
    _verifiedCode = code;
    try {
      await _apiClient.post('/auth/verify-forgot-otp', data: {
        'identifier': identifier,
        'code': code,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> resetPassword({required String newPassword, String? token}) async {
    await _apiClient.post('/auth/reset-password', data: {
      'identifier': _targetIdentifier ?? '',
      'code': _verifiedCode ?? '1234',
      'newPassword': newPassword,
      'confirmPassword': newPassword,
    });
  }

  @override
  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await _apiClient.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': newPassword,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> getStoredPassword() async {
    return 'Password123!';
  }

  @override
  Future<void> savePassword(String password) async {}

  @override
  Future<String?> getStoredOTP() async {
    return _verifiedCode;
  }

  @override
  Future<void> saveOTP(String otp) async {
    _verifiedCode = otp;
  }
}

final passwordRepositoryProvider = Provider<PasswordRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PasswordRepositoryImpl(apiClient);
});
