import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrimony_app/core/config/app_config.dart';
import 'package:matrimony_app/core/network/api_client.dart';
import 'package:matrimony_app/core/network/socket_service.dart';
import 'package:matrimony_app/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  group('AppConfig Automatic Environment Switching Tests', () {
    test('Automatic development mode resolution during normal run/test', () {
      // In test/debug mode, AppConfig automatically defaults to development and .env.development
      expect(AppConfig.appEnv, 'development');
      expect(AppConfig.isDevelopment, isTrue);
      expect(AppConfig.isProduction, isFalse);
      expect(AppConfig.envFileName, '.env.development');
    });

    test('Handles uninitialized dotenv safely with development defaults', () {
      final baseUrl = AppConfig.apiBaseUrl;
      expect(baseUrl.isNotEmpty, isTrue);
      expect(baseUrl.endsWith('/api'), isTrue);

      final socketUrl = AppConfig.socketUrl;
      expect(socketUrl.isNotEmpty, isTrue);
      expect(socketUrl.endsWith('/api'), isFalse);
    });

    test('Reads local development URL when .env.development is loaded', () {
      dotenv.loadFromString(
        envString: 'API_BASE_URL=http://10.0.2.2:8000/api\n',
      );

      expect(AppConfig.apiBaseUrl, 'http://10.0.2.2:8000/api');
      expect(AppConfig.socketUrl, 'http://10.0.2.2:8000');
      expect(ApiClient.getBaseUrl(), 'http://10.0.2.2:8000/api');

      final socketService = SocketService(
        SecureStorageService(const FlutterSecureStorage()),
      );
      expect(socketService.getSocketUrl(), 'http://10.0.2.2:8000');
    });

    test('Reads production URL when .env.production is loaded', () {
      dotenv.loadFromString(
        envString: 'API_BASE_URL=https://matrimony-apk-1.onrender.com/api\n',
      );

      expect(AppConfig.apiBaseUrl, 'https://matrimony-apk-1.onrender.com/api');
      expect(AppConfig.socketUrl, 'https://matrimony-apk-1.onrender.com');
      expect(ApiClient.getBaseUrl(), 'https://matrimony-apk-1.onrender.com/api');
    });

    test('Normalizes URLs missing /api suffix', () {
      dotenv.loadFromString(
        envString: 'API_BASE_URL=http://localhost:8000\n',
      );

      expect(AppConfig.apiBaseUrl, 'http://localhost:8000/api');
      expect(AppConfig.socketUrl, 'http://localhost:8000');
    });
  });
}
