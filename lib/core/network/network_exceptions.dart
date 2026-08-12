import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;

  factory NetworkException.fromDioException(DioException dioException) {
    String message = 'Unexpected error occurred';
    int? statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;
      case DioExceptionType.badResponse:
        final data = dioException.response?.data;
        if (data is Map && data.containsKey('message')) {
          message = data['message'];
        } else {
          message = 'Server error ($statusCode)';
        }
        break;
      default:
        message = 'Something went wrong';
        break;
    }

    return NetworkException(message, statusCode: statusCode);
  }
}
