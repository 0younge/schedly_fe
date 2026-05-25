import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _configuredBaseUrl = String.fromEnvironment(
    'SCHEDLY_API_BASE_URL',
  );

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _withoutTrailingSlash(_configuredBaseUrl);
    }

    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }

    return 'http://localhost:8080';
  }

  static String _withoutTrailingSlash(String value) {
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }
}
