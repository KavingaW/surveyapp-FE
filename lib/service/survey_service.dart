import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/survey_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/service/service_constants.dart';

import '../interceptor/request_interceptor.dart';
import '../model/suvey_assigned_model.dart';
import '../model/user_admin_response_model.dart';
import '../utils/constants.dart';

class SurveyService {
  String surveyServiceUrl = ServiceConstants.SURVEY_SERVICE_URL;

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<Survey> addSurvey(Survey survey) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.post(
      Uri.parse('$surveyServiceUrl/add'),
      body: json.encode(Survey.surveyToJson(survey)),
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      return Survey.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }

  Future<List<Survey>> getSurveyList() async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$surveyServiceUrl/list'),
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

    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$surveyServiceUrl/$surveyId'),
    );
    if (response.statusCode == 200) {
      return Survey.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<List<Survey>> getUserAssignedSurveyList(String userId) async {

    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$surveyServiceUrl/list/$userId'),
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
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.delete(
      Uri.parse('$surveyServiceUrl/$surveyId'),
    );
    if (response.statusCode == 200) {
      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<Survey> updateSurvey(String surveyId, Survey survey) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.put(
      Uri.parse('$surveyServiceUrl/$surveyId'),
      body: json.encode(Survey.surveyToJson(survey)),
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      return Survey.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }

  Future<SurveyAssignedUsers> updateSurveyWithAssignedUsers(
      String surveyId, Survey survey) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    List<Question> questions = survey.questions;
    List<User> users = survey.assigned;


    List<UserAssigned> createSurveyAssignedList(List<User> users) {
      return users.map((user) => UserAssigned(id: user.id)).toList();
    }

    List<UserAssigned> assignedList = createSurveyAssignedList(users);

    SurveyAssignedUsers surveyAssignedUsers = SurveyAssignedUsers(
        id: survey.id,
        title: survey.title,
        description: survey.description,
        questions: questions,
        assigned: assignedList);

    final response = await client.put(
      Uri.parse('$surveyServiceUrl/$surveyId'),
      body: json.encode(SurveyAssignedUsers.surveyToJson(surveyAssignedUsers)),
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      return SurveyAssignedUsers.fromJson(decodedJson);
    } else {
      throw Exception('Failed to get survey details');
    }
  }
}
