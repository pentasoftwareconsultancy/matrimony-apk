import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/password_repository.dart';

class PasswordState {
  final int selectedTabIndex; // 0: Phone, 1: Email
  final String phone;
  final String email;
  final String otp;
  final int timerSeconds;
  final bool canResend;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final String? error;
  final String? currentPasswordError;
  final String? phoneError;
  final String? emailError;

  PasswordState({
    this.selectedTabIndex = 0,
    this.phone = '',
    this.email = '',
    this.otp = '',
    this.timerSeconds = 30,
    this.canResend = false,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.error,
    this.currentPasswordError,
    this.phoneError,
    this.emailError,
  });

  PasswordState copyWith({
    int? selectedTabIndex,
    String? phone,
    String? email,
    String? otp,
    int? timerSeconds,
    bool? canResend,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? error,
    String? currentPasswordError,
    String? phoneError,
    String? emailError,
  }) {
    return PasswordState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      canResend: canResend ?? this.canResend,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPasswordError: currentPasswordError,
      phoneError: phoneError,
      emailError: emailError,
    );
  }

  // Password Validation Rules
  bool get hasMinLength => newPassword.length >= 8;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(newPassword);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(newPassword);
  bool get hasDigit => RegExp(r'[0-9]').hasMatch(newPassword);
  bool get hasSpecialChar => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPassword);

  int get strengthScore {
    if (newPassword.isEmpty) return 0;
    int score = 0;
    if (hasMinLength) score++;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasDigit) score++;
    if (hasSpecialChar) score++;

    if (score <= 2) return 1; // Weak
    if (score <= 4) return 2; // Medium
    return 3; // Strong
  }

  bool get isNewPasswordValid =>
      hasMinLength && hasUppercase && hasLowercase;

  bool get doPasswordsMatch =>
      newPassword.isNotEmpty && newPassword == confirmPassword;

  bool get isPhoneValid =>
      phone.trim().length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone.trim());

  bool get isEmailValid =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());

  String get activeRecipient => selectedTabIndex == 0 ? phone : email;
}

class PasswordController extends StateNotifier<PasswordState> {
  final PasswordRepository _repository;
  Timer? _timer;

  PasswordController(this._repository) : super(PasswordState());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index, phoneError: null, emailError: null);
  }

  void setPhone(String phone) {
    String? error;
    final trimmed = phone.trim();
    if (trimmed.isNotEmpty && (trimmed.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(trimmed))) {
      error = 'Please enter exactly 10 digits';
    }
    state = state.copyWith(phone: phone, phoneError: error);
  }

  void setEmail(String email) {
    String? error;
    final trimmed = email.trim();
    if (trimmed.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed)) {
      error = 'Please enter a valid email';
    }
    state = state.copyWith(email: email, emailError: error);
  }

  void setCurrentPassword(String password) {
    state = state.copyWith(currentPassword: password, currentPasswordError: null);
  }

  void setNewPassword(String password) {
    state = state.copyWith(newPassword: password);
  }

  void setConfirmPassword(String password) {
    state = state.copyWith(confirmPassword: password);
  }

  void setOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  Future<bool> sendForgotPasswordOtp() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isPhone = state.selectedTabIndex == 0;
      final target = isPhone ? state.phone.trim() : state.email.trim();

      if (isPhone && !state.isPhoneValid) {
        state = state.copyWith(isLoading: false, phoneError: 'Please enter valid 10 digits');
        return false;
      }
      if (!isPhone && !state.isEmailValid) {
        state = state.copyWith(isLoading: false, emailError: 'Please enter valid email');
        return false;
      }

      const generatedOtp = '1234';
      await _repository.sendOTP(
        email: isPhone ? null : target,
        phoneNumber: isPhone ? target : null,
        otp: generatedOtp,
      );

      state = state.copyWith(isLoading: false, otp: '');
      startTimer();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(timerSeconds: 30, canResend: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 1) {
        state = state.copyWith(timerSeconds: state.timerSeconds - 1);
      } else {
        state = state.copyWith(timerSeconds: 0, canResend: true);
        _timer?.cancel();
      }
    });
  }

  Future<bool> resendOtp() async {
    if (!state.canResend) return false;
    const generatedOtp = '1234';
    final isPhone = state.selectedTabIndex == 0;
    await _repository.sendOTP(
      email: isPhone ? null : state.email.trim(),
      phoneNumber: isPhone ? state.phone.trim() : null,
      otp: generatedOtp,
    );
    startTimer();
    return true;
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    state = state.copyWith(isLoading: true, error: null);
    final isValid = await _repository.verifyOTP(
      email: state.selectedTabIndex == 1 ? state.email.trim() : null,
      phoneNumber: state.selectedTabIndex == 0 ? state.phone.trim() : null,
      code: enteredOtp,
    );

    if (isValid) {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Invalid OTP code');
      return false;
    }
  }

  Future<bool> resetPassword() async {
    if (!state.isNewPasswordValid || !state.doPasswordsMatch) {
      state = state.copyWith(error: 'Please ensure passwords match and meet security rules.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.resetPassword(newPassword: state.newPassword);
      state = state.copyWith(
        isLoading: false,
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> changePassword() async {
    if (state.currentPassword.isEmpty) {
      state = state.copyWith(currentPasswordError: 'Please enter current password');
      return false;
    }

    if (!state.isNewPasswordValid || !state.doPasswordsMatch) {
      state = state.copyWith(error: 'Please enter a valid new password');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null, currentPasswordError: null);
    try {
      final success = await _repository.changePassword(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          currentPassword: '',
          newPassword: '',
          confirmPassword: '',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          currentPasswordError: 'Incorrect current password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null, currentPasswordError: null, phoneError: null, emailError: null);
  }
}

final passwordControllerProvider =
    StateNotifierProvider<PasswordController, PasswordState>((ref) {
  final repository = ref.watch(passwordRepositoryProvider);
  return PasswordController(repository);
});
