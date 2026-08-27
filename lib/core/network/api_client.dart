import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'jwt_interceptor.dart';
import 'network_exceptions.dart';

class ApiClient {
  final Dio _dio;

  static String getBaseUrl() {
    return 'https://matrimony-apk-1.onrender.com/api';
  }

  ApiClient(this._dio, SecureStorageService secureStorage) {
    _dio.options = BaseOptions(
      baseUrl: getBaseUrl(),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
    );

    // Add JWT & Interceptors
    _dio.interceptors.add(JWTInterceptor(secureStorage));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          debugPrint('[API Request] ${options.method} ${options.path}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('[API Response] ${response.statusCode} ${response.requestOptions.path}');
        }
        return handler.next(response);
      },
      onError: (DioException err, handler) {
        if (kDebugMode) {
          debugPrint('[API Error] ${err.response?.statusCode ?? 'NET'} ${err.requestOptions.path}: ${err.message}');
        }
        return handler.next(err);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}

final dioInstanceProvider = Provider<Dio>((ref) => Dio());

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioInstanceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(dio, secureStorage);
});
