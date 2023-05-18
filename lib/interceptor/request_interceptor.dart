import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _client;
  final SharedPreferences _preferences;

  AuthInterceptor(this._client, this._preferences);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(_addHeaders(request));
  }

  http.BaseRequest _addHeaders(http.BaseRequest request) {
    final token = _preferences.getString(AppConstants.token);
    return request..headers.addAll(<String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }
}