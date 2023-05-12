import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/user_token_response.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/auth';

  Future<User> login(String username, String password) async {
    final body = json.encode({'username': username, 'password': password});
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('$baseUrl/signin'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }
}
