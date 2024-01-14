import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:surveyapp/model/survey_api_model.dart';
import 'package:surveyapp/service/service_constants.dart';

import '../interceptor/request_interceptor.dart';

class QuestionService {
  String questionServiceUrl = ServiceConstants.QUESTION_SERVICE_URL;

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<Question> addQuestion(String surveyId, Question question) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.post(
      Uri.parse('$questionServiceUrl/$surveyId'),
      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      return Question.fromJson(jsonData);
    } else {
      throw Exception('Failed to get question details');
    }
  }

  Future<void> updateQuestion(String questionId, Question question) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.put(
      Uri.parse('$questionServiceUrl/$questionId'),
      body: json.encode(question.questionToJson(question)),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<String> deleteQuestion(String questionId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.delete(
      Uri.parse('$questionServiceUrl/$questionId'),
    );
    if (response.statusCode == 200) {
      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }
}
