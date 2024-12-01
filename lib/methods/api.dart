import 'dart:convert';
import 'package:http/http.dart' as http;

String apiUrl = "https://api.totomonkey.com/api/auth";

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route; // Full URL with the scheme
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _header(),
    );
  }

  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
