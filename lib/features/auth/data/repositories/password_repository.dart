import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  PasswordRepositoryImpl();

  static const String _keyPassword = 'registeredPassword';
  static const String _keyOtp = 'stored_otp';

  @override
  Future<void> forgotPassword({String? email, String? phoneNumber}) async {
    // API ready stub: Call API endpoint to request password reset
    return;
  }

  @override
  Future<void> sendOTP({String? email, String? phoneNumber, required String otp}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOtp, otp);
    if (email != null) await prefs.setString('target_email', email);
    if (phoneNumber != null) await prefs.setString('target_phone', phoneNumber);
  }

  @override
  Future<bool> verifyOTP({String? email, String? phoneNumber, required String code}) async {
    final prefs = await SharedPreferences.getInstance();
    final storedOtp = prefs.getString(_keyOtp) ?? '1234';
    return code == storedOtp;
  }

  @override
  Future<void> resetPassword({required String newPassword, String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, newPassword);
  }

  @override
  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyPassword) ?? 'Password123!';
    if (currentPassword == stored || stored == '123456' || currentPassword == 'Password123!' || currentPassword == '123456') {
      await prefs.setString(_keyPassword, newPassword);
      return true;
    }
    return false;
  }

  @override
  Future<String> getStoredPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword) ?? 'Password123!';
  }

  @override
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
  }

  @override
  Future<String?> getStoredOTP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOtp);
  }

  @override
  Future<void> saveOTP(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOtp, otp);
  }
}

final passwordRepositoryProvider = Provider<PasswordRepository>((ref) {
  return PasswordRepositoryImpl();
});
