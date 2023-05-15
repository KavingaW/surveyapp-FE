import 'dart:convert';

import 'package:surveyapp/model/survey_api_response.dart';
import 'package:http/http.dart' as http;

class SurveyService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/survey';

  Future<Survey> addSurvey(String token, Survey survey) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(Survey.surveyToJson(survey)),
    );

    if (response.statusCode == 200) {
      //return jsonDecode(response.body);

      final decodedJson = jsonDecode(response.body);
      return Survey.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }

  Future<List<Survey>> getSurveyList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/list'),
      // headers: <String, String>{
      //   'Authorization': 'Bearer $token',
      // },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<Survey> surveyList =
          jsonData.map((e) => Survey.fromJson(e)).toList();
      return surveyList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<Survey> getSurvey(surveyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$surveyId'),
      // headers: <String, String>{
      //   'Authorization': 'Bearer $token',
      // },
    );
    if (response.statusCode == 200) {
      return Survey.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<List<Survey>> getUserAssignedSurveyList(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/list/$userId'),
      // headers: <String, String>{
      //   'Authorization': 'Bearer $token',
      // },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<Survey> surveyList =
          jsonData.map((e) => Survey.fromJson(e)).toList();
      return surveyList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<String> deleteSurvey(String token, String surveyId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$surveyId'),
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

  Future<Survey> updateSurvey(
      String token, String surveyId, Survey survey) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$surveyId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(Survey.surveyToJson(survey)),
    );

    if (response.statusCode == 200) {
      print("OK");
      final decodedJson = jsonDecode(response.body);
      return Survey.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }
}
