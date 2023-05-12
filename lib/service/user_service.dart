import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/user_response.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/user';

  Future<Map<String, dynamic>> getLoggedInUserDetails(
      String token, int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<List<User>> getUserList(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<User> userList = jsonData.map((e) => User.fromJson(e)).toList();
      return userList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<String> deleteUser(String token, String userId) async {
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

  Future<void> updateUser(String token, String userId, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(user.toJson(user)),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }
}
