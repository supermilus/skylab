import 'package:http/http.dart' as http;
import 'dart:convert';

class AtprotoAuthService {
  final String baseUrl = 'https://bsky.social/xrpc';

  Future<bool> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/com.atproto.server.createSession'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );
      // Store session as needed
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String handle, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/com.atproto.server.createAccount'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'handle': handle,
          'password': password,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
