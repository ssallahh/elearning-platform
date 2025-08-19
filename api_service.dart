import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _baseUrl = 'https://api.yourdomain.com';
  static const Duration _timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');
      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await http
          .post(
            uri,
            headers: requestHeaders,
            body: json.encode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, String>> _getHeaders(
    Map<String, String>? additionalHeaders,
    bool requiresAuth,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?additionalHeaders,
    };

    if (requiresAuth) {
      // Add authentication token here
      final token = await _getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<String?> _getAuthToken() async {
    // Implement your token retrieval logic here
    // For example, from shared preferences
    return null;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw HttpException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        statusCode: response.statusCode,
      );
    }
  }

  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error: Please check your internet connection';
    } else if (error is TimeoutException) {
      return 'Request timeout: Please try again';
    } else if (error is HttpException) {
      return error.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, {this.statusCode = 0});

  @override
  String toString() => message;
}