import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class JWTInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  JWTInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
