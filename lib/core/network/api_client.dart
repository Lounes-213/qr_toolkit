import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_toolkit/core/errors/exceptions.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query});
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});
}

class HttpApiClient implements ApiClient {
  final String baseUrl;
  final http.Client client;

  const HttpApiClient({required this.baseUrl, required this.client});

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final response = await client.get(uri);
    return _handle(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(response);
  }

  Map<String, dynamic> _handle(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw ServerException('Request failed: ${response.statusCode}');
  }
}
