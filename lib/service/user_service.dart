import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/user_request_model.dart';
import 'package:surveyapp/service/service_constants.dart';

import '../interceptor/request_interceptor.dart';
import '../model/user_admin_response_model.dart';
import '../utils/constants.dart';

class UserService {
  String userServiceUrl = ServiceConstants.USER_SERVICE_URL;

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<Map<String, dynamic>> addUser(UserRequest user) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.post(
      Uri.parse('${ServiceConstants.AUTH_SERVICE_URL}/signup'),
      body: json.encode(user.toJson(user)),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<Map<String, dynamic>> resetUserPassword(UserRequest user) async {
    final response = await http.post(
      Uri.parse('${ServiceConstants.AUTH_SERVICE_URL}/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson(user)),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<User> getLoggedInUserDetails(String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$userServiceUrl/$userId'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      User user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<List<User>> getUserList() async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);
    final response = await client.get(
      Uri.parse('$userServiceUrl/list'),
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<User> userList = jsonData.map((e) => User.fromJson(e)).toList();
      return userList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<String> deleteUser(String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.delete(
      Uri.parse('$userServiceUrl/$userId'),
    );
    if (response.statusCode == 200) {
      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<User> updateUser(String userId, User user) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.put(
      Uri.parse('$userServiceUrl/$userId'),
      body: json.encode(user.toJson(user)),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<User> getUserById(String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$userServiceUrl/$userId'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception("Error on fetching data");
    }
  }
}
