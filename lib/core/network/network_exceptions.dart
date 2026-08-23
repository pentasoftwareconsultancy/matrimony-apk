import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;

  factory NetworkException.fromDioException(DioException dioException) {
    String message = 'Something went wrong. Please try again.';
    int? statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timed out. Please try again.';
        break;

      case DioExceptionType.badResponse:
        final data = dioException.response?.data;
        if (data is Map) {
          if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
            message = data['message'].toString();
          } else if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
            message = data['error'].toString();
          } else if (data['errors'] is Map) {
            final errMap = data['errors'] as Map;
            message = errMap.values.join(', ');
          } else {
            message = _getDefaultMessageForStatus(statusCode);
          }
        } else if (data is String && data.trim().isNotEmpty) {
          message = data;
        } else {
          message = _getDefaultMessageForStatus(statusCode);
        }
        break;

      case DioExceptionType.connectionError:
        // Genuine socket/network connection failure
        message = 'Unable to connect to backend server. Please verify the backend server is running.';
        break;

      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;

      default:
        final data = dioException.response?.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else if (statusCode != null) {
          message = _getDefaultMessageForStatus(statusCode);
        } else {
          message = 'Unable to connect to backend server. Please verify the backend server is running.';
        }
        break;
    }

    return NetworkException(message, statusCode: statusCode);
  }

  static String _getDefaultMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request parameters';
      case 401:
        return 'Invalid mobile/email or password';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'User not registered. Please register first.';
      case 409:
        return 'Mobile number or email already registered';
      case 422:
        return 'Validation error';
      case 500:
        return 'Something went wrong. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
