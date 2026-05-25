import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiClient {
  ApiClient({
    String? baseUrl,
    http.Client? httpClient,
  })  : baseUrl = baseUrl ?? ApiConfig.baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;

  Future<Map<String, Object?>> postJson(
    String path,
    Map<String, Object?> body,
  ) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final decodedBody = _decodeObject(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    throw ApiException(
      statusCode: response.statusCode,
      code: decodedBody['code'] as String?,
      message: decodedBody['message'] as String? ?? 'Request failed.',
    );
  }

  Map<String, Object?> _decodeObject(String body) {
    if (body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }

    return {};
  }
}

class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.message,
    this.code,
  });

  final int statusCode;
  final String? code;
  final String message;

  @override
  String toString() => message;
}
