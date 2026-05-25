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
    Map<String, Object?> body, {
    String? authorization,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(authorization),
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

  Future<List<Object?>> getJsonList(
    String path, {
    Map<String, String> queryParameters = const {},
    String? authorization,
  }) async {
    final response = await _httpClient.get(
      Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters),
      headers: _headers(authorization),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _decodeList(response.body);
    }

    final decodedBody = _decodeObject(response.body);
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

  List<Object?> _decodeList(String body) {
    if (body.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(body);
    if (decoded is List<Object?>) {
      return decoded;
    }

    return [];
  }

  Map<String, String> _headers(String? authorization) {
    return {
      'Content-Type': 'application/json',
      if (authorization != null) 'Authorization': authorization,
    };
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
