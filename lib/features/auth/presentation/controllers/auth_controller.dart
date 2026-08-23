import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;
  final bool isAuthenticated;
  final String? tempEmail;
  final String? tempPhone;
  final bool isNewUser;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.isAuthenticated = false,
    this.tempEmail,
    this.tempPhone,
    this.isNewUser = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    bool? isAuthenticated,
    String? tempEmail,
    String? tempPhone,
    bool? isNewUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Clears error if set to null, or set explicitly
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      tempEmail: tempEmail ?? this.tempEmail,
      tempPhone: tempPhone ?? this.tempPhone,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  AuthController(this._authRepository, this._secureStorage) : super(AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _secureStorage.getToken();
      if (token != null) {
        final user = await _authRepository.getMe();
        state = AuthState(user: user, isAuthenticated: true);
      } else {
        state = AuthState(isAuthenticated: false);
      }
    } catch (e) {
      await _secureStorage.deleteToken();
      state = AuthState(isAuthenticated: false);
    }
  }

  void setAuthenticatedState(User user) {
    state = AuthState(user: user, isAuthenticated: true);
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _authRepository.login(email: email, password: password);
      final user = result['user'] as User;
      final token = result['token'] as String;

      await _secureStorage.saveToken(token);
      state = AuthState(user: user, isAuthenticated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> getOTP({String? email, String? phoneNumber}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final identifier = email ?? phoneNumber ?? '';
      final exists = await _authRepository.checkUser(identifier);

      if (exists) {
        await _authRepository.sendOTP(email: email, phoneNumber: phoneNumber);
        state = state.copyWith(
          isLoading: false,
          tempEmail: email,
          tempPhone: phoneNumber,
          isNewUser: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'User not registered. Please register first.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> verifyOTP(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _authRepository.verifyOTP(
        email: state.tempEmail,
        phoneNumber: state.tempPhone,
        code: code,
      );
      final user = result['user'] as User;
      final token = result['token'] as String;

      await _secureStorage.saveToken(token);
      state = AuthState(user: user, isAuthenticated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _secureStorage.deleteToken();
    state = AuthState(isAuthenticated: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetNewUserFlag() {
    state = state.copyWith(isNewUser: false);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthController(authRepository, secureStorage);
});
