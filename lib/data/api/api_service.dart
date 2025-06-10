import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hobby_reads_flutter/data/repository/token_manager_repository.dart';

class ApiService {
  final String baseUrl;
  final TokenManagerRepository _tokenManager;
  final http.Client _client;

  ApiService({
    required this.baseUrl,
    required TokenManagerRepository tokenManager,
    http.Client? client,
  }) : _tokenManager = tokenManager,
       _client = client ?? http.Client();

  // HTTP Headers
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = _tokenManager.getFormattedToken();
      if (token != null) {
        headers['Authorization'] = token;
      }
    }

    return headers;
  }

  // HTTP Methods
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.get(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make GET request: $e');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.post(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth),
        body: body != null ? json.encode(body) : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make POST request: $e');
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.put(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth),
        body: body != null ? json.encode(body) : null,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make PUT request: $e');
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.patch(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth),
        body: body != null ? json.encode(body) : null,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to patch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make PATCH request: $e');
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.delete(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make DELETE request: $e');
    }
  }

  // File Upload
  Future<dynamic> uploadFile(
    String endpoint,
    List<int> fileBytes,
    String fileName, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll(await _getHeaders(requiresAuth: requiresAuth));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Cleanup
  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException: [$statusCode] $message';
} 