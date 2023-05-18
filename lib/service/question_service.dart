import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:surveyapp/model/survey_api_response.dart';

import '../screens/survey_details_screen.dart';
import '../utils/constants.dart';

class QuestionService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/question';

  Future<Question> addQuestion(String surveyId, Question question) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 201) {
      print("OK");
      var jsonData = jsonDecode(response.body);
      return Question.fromJson(jsonData);
      // Question added successfully
    } else {
      // Error adding question
      throw Exception('Failed to get question details');
    }
  }

  Future<void> updateQuestion(String questionId, Question question) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.put(
      Uri.parse('$baseUrl/$questionId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(question.questionToJson(question)),
    );

    if (response.statusCode == 200) {
      print("OK");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<String> deleteQuestion(String questionId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstants.token);

    final response = await http.delete(
      Uri.parse('$baseUrl/$questionId'),
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
}
