import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized application configuration with automatic environment switching:
/// - Debug mode (normal Run/Debug in Android Studio & Antigravity) -> Development (.env.development)
/// - Release mode (flutter build apk / release builds) -> Production (.env.production)
class AppConfig {
  static const String _productionFallbackUrl = 'https://matrimony-apk-1.onrender.com/api';
  static const String _developmentFallbackUrl = 'http://10.0.2.2:8000/api';

  /// Resolves the active environment name automatically:
  /// 1. If explicit --dart-define=APP_ENV is provided, respect it.
  /// 2. Otherwise automatically: kReleaseMode -> 'production', Debug/Profile -> 'development'.
  static String get appEnv {
    const cliEnv = String.fromEnvironment('APP_ENV');
    if (cliEnv.trim().isNotEmpty) {
      return cliEnv.trim().toLowerCase();
    }
    return kReleaseMode ? 'production' : 'development';
  }

  /// Whether running in development mode
  static bool get isDevelopment => appEnv == 'development' || appEnv == 'dev';

  /// Whether running in production mode
  static bool get isProduction => !isDevelopment;

  /// The target environment file (.env.development or .env.production)
  static String get envFileName => isDevelopment ? '.env.development' : '.env.production';

  /// Safe helper to read from dotenv without throwing NotInitializedError
  static String? _getEnvVar(String key) {
    try {
      if (!dotenv.isInitialized) return null;
      return dotenv.maybeGet(key);
    } catch (_) {
      return null;
    }
  }

  /// Loads the matching environment file based on the build mode.
  static Future<void> initialize() async {
    final fileName = envFileName;
    try {
      await dotenv.load(fileName: fileName);
      debugPrint('[AppConfig] Loaded environment file: $fileName (mode: ${kReleaseMode ? "RELEASE" : "DEBUG"}, APP_ENV=$appEnv)');
    } catch (e) {
      debugPrint('[AppConfig] Notice: Could not load $fileName from assets ($e).');
      // If primary file fails, try fallback
      try {
        final fallback = isDevelopment ? '.env.production' : '.env.development';
        await dotenv.load(fileName: fallback);
        debugPrint('[AppConfig] Loaded alternate environment file: $fallback');
      } catch (_) {
        debugPrint('[AppConfig] Using built-in environment defaults.');
      }
    }
  }

  /// Centralized API Base URL for all REST API services.
  static String get apiBaseUrl {
    String resolvedUrl = '';

    // 1. Read from loaded .env file
    final envUrl = _getEnvVar('API_BASE_URL');
    if (envUrl != null && envUrl.trim().isNotEmpty) {
      resolvedUrl = _normalizeApiUrl(envUrl.trim());
    }

    // 2. Read from --dart-define=API_BASE_URL if explicitly passed
    if (resolvedUrl.isEmpty) {
      const cliDefine = String.fromEnvironment('API_BASE_URL');
      if (cliDefine.trim().isNotEmpty) {
        resolvedUrl = _normalizeApiUrl(cliDefine.trim());
      }
    }

    // 3. Fallback based on environment
    if (resolvedUrl.isEmpty) {
      resolvedUrl = isDevelopment ? _developmentFallbackUrl : _productionFallbackUrl;
    }

    // CRITICAL SAFEGUARD: Release builds must NEVER accidentally use localhost or local IPs
    if (kReleaseMode && _isLocalHostUrl(resolvedUrl)) {
      debugPrint('[AppConfig] CRITICAL WARNING: Release build attempted to use local URL "$resolvedUrl". Forcing production backend URL.');
      resolvedUrl = _productionFallbackUrl;
    }

    return resolvedUrl;
  }

  /// Centralized WebSocket server URL derived from the API Base URL.
  static String get socketUrl {
    final envSocket = _getEnvVar('SOCKET_URL');
    if (envSocket != null && envSocket.trim().isNotEmpty) {
      // Safeguard: no localhost in release builds
      if (kReleaseMode && _isLocalHostUrl(envSocket)) {
        return _productionFallbackUrl.replaceAll(RegExp(r'/api/?$'), '');
      }
      return envSocket.trim();
    }

    // Derive root origin from apiBaseUrl
    final base = apiBaseUrl;
    try {
      final uri = Uri.parse(base);
      final portSuffix = (uri.hasPort && uri.port != 80 && uri.port != 443) ? ':${uri.port}' : '';
      return '${uri.scheme}://${uri.host}$portSuffix';
    } catch (_) {
      return base.replaceAll(RegExp(r'/api/?$'), '');
    }
  }

  static bool _isLocalHostUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('localhost') ||
        lower.contains('127.0.0.1') ||
        lower.contains('10.0.2.2') ||
        lower.contains('192.168.');
  }

  static String _normalizeApiUrl(String url) {
    var trimmed = url.trim();
    while (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    if (!trimmed.endsWith('/api')) {
      trimmed = '$trimmed/api';
    }
    return trimmed;
  }
}
