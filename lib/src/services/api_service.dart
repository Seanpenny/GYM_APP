import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // On web, GitHub Pages needs a public API URL supplied at build time.
  static const String _webBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const String _mobileBaseUrl = 'http://192.168.0.34:3000';

  static String get baseUrl => kIsWeb ? _webBaseUrl : _mobileBaseUrl;

  static Map<String, dynamic>? _missingBaseUrlError() {
    if (baseUrl.isNotEmpty) return null;
    return {
      'success': false,
      'error':
          'API base URL is not configured for web deployment. Rebuild with --dart-define=API_BASE_URL=https://your-api-host',
    };
  }

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final configError = _missingBaseUrlError();
      if (configError != null) return configError;

      final response = await http.post(
        Uri.parse('$baseUrl/api/mobile/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      // Check if response body is empty or not valid JSON
      if (response.body.isEmpty) {
        return {'success': false, 'error': 'Empty response from server. Is backend running?'};
      }

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {'success': false, 'error': 'Invalid response format: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}'};
      }

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}. Check if backend is running at $baseUrl'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final configError = _missingBaseUrlError();
      if (configError != null) return configError;

      final response = await http.post(
        Uri.parse('$baseUrl/api/mobile/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      // Check if response body is empty or not valid JSON
      if (response.body.isEmpty) {
        return {'success': false, 'error': 'Empty response from server. Is backend running?'};
      }

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {'success': false, 'error': 'Invalid response format: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}'};
      }

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}. Check if backend is running at $baseUrl'};
    }
  }
}

