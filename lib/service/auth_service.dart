import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/user_token_response.dart';

class AuthService {

  String? baseUrl = dotenv.env['AUTH_BASE_URL'];

  Future<User> login(String username, String password) async {
    final body = json.encode({'username': username, 'password': password});
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('$baseUrl/signin'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);

      var accessToken = user.accessToken;
      print(accessToken);
      preferences.setString(AppConstants.token, accessToken);

      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> deleteUser(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.delete(
      Uri.parse('$baseUrl/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // var jsonData = jsonDecode(response.body) as List;
      // List<User> userList = jsonData.map((e) => User.fromJson(e)).toList();

      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<void> logOut()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
