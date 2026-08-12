import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'jwt_interceptor.dart';
import 'network_exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio, SecureStorageService secureStorage) {
    _dio.options = BaseOptions(
      baseUrl: kIsWeb
          ? 'http://localhost:5000/api'
          : (Platform.isAndroid ? 'http://10.0.2.2:5000/api' : 'http://localhost:5000/api'),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    );

    // Add JWT & Log Interceptors
    _dio.interceptors.add(JWTInterceptor(secureStorage));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
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
