import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/user_request.dart';

import '../interceptor/request_interceptor.dart';
import '../model/user_admin_response.dart';
import '../utils/constants.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/user';


  Future<Map<String, dynamic>> addUser(UserRequest user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(user.toJson(user)),
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else {
      throw Exception('Failed to get user details');
    }

  }
  Future<Map<String, dynamic>> getLoggedInUserDetails(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

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

  Future<List<User>> getUserList() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var token = preferences.getString(AppConstants.token);

   final preferences = await SharedPreferences.getInstance();
    final client = AuthInterceptor(http.Client(), preferences);
    final response = await client.get(
      Uri.parse('$baseUrl/list'),
      // headers: <String, String>{
      //   'Authorization': 'Bearer $token',
      // },
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

  Future<User> updateUser(String userId, User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      print('USERNAME' + user.username);
      return user;
    } else {
      throw Exception("Error on fetching data");
    }
  }
}
