import 'dart:convert';

import 'package:surveyapp/model/survey_api_response.dart';
import 'package:http/http.dart' as http;

class SurveyService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/survey';

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



}
