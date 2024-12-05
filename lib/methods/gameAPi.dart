import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GameApiService {
  static const String apiUrl = "https://api.totomonkey.com/api";
  static const _secureStorage = FlutterSecureStorage();

  Future<http.Response> postRequestData({
    required String route,
    required Map<String, String> data,
  }) async {
    final String url = apiUrl + route;
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _headers(token),
    );
  }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Include the token
    };
  }
}
