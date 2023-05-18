import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/survey_api_response.dart';
import 'package:http/http.dart' as http;
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';

import '../model/suvey_assigned_request.dart';
import '../utils/constants.dart';

class SurveyService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/survey';

  Future<Survey> addSurvey(Survey survey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

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

  Future<String> deleteSurvey(String surveyId, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.delete(
      Uri.parse('$baseUrl/$surveyId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // var jsonData = jsonDecode(response.body) as List;
      // List<User> userList = jsonData.map((e) => User.fromJson(e)).toList();
      //   Navigator.push(
      //     context!,
      //     MaterialPageRoute(
      //         builder: (context) => SurveyListScreen(),
      // ));
      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<Survey> updateSurvey(String surveyId, Survey survey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

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

  Future<SurveyAssignedUsers> updateSurveyWithAssignedUsers(
      String surveyId, Survey survey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    List<Question> questions = survey.questions;
    List<String> userIds = survey.assigned;
    print('users $userIds');

    List<UserAssigned> createSurveyAssignedList(List<String> ids) {
      return ids.map((id) => UserAssigned(id: id)).toList();
    }

    List<UserAssigned> assignedList = createSurveyAssignedList(userIds);

    SurveyAssignedUsers surveyAssignedUsers = SurveyAssignedUsers(
        id: survey.id,
        title: survey.title,
        description: survey.description,
        questions: questions,
        assigned: assignedList);

    final response = await http.put(
      Uri.parse('$baseUrl/$surveyId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(SurveyAssignedUsers.surveyToJson(surveyAssignedUsers)),
    );

    if (response.statusCode == 200) {
      print("OK");
      final decodedJson = jsonDecode(response.body);
      return SurveyAssignedUsers.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }
}
