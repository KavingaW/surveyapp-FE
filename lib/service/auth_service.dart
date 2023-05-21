import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/service/service_constants.dart';
import 'package:surveyapp/utils/constants.dart';

import '../interceptor/request_interceptor.dart';
import '../model/user_token_response_model.dart';

class AuthService {
  String authServiceUrl = ServiceConstants.AUTH_SERVICE_URL;

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<User> login(String username, String password) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final body = json.encode({'username': username, 'password': password});

    final response =
        await client.post(Uri.parse('$authServiceUrl/signin'), body: body);

    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      var accessToken = user.accessToken;
      preferences.setString(AppConstants.token, accessToken);
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> deleteUser(String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.delete(
      Uri.parse('$authServiceUrl/$userId'),
    );
    if (response.statusCode == 200) {
      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<void> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
