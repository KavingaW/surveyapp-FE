import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/result_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:surveyapp/service/service_constants.dart';
import '../interceptor/request_interceptor.dart';
import '../model/survey_api_model.dart';
import '../model/survey_result.dart';
import '../utils/constants.dart';

class SurveyResultService {
  String surveyResultServiceUrl = ServiceConstants.SURVEY_RESULT_SERVICE_URL;
  late String userId;

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<List<SurveyResultResponse>> getSurveyList() async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(Uri.parse('$surveyResultServiceUrl/$userId'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<SurveyResultResponse> surveyList =
          jsonData.map((e) => SurveyResultResponse.fromJson(e)).toList();
      return surveyList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<List<Survey>> getRespondedSurveys() async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(
      Uri.parse('$surveyResultServiceUrl/list'),
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

  Future<List<Survey>> getUserCompletedSurveyList(String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(Uri.parse('$surveyResultServiceUrl/assigned/$userId'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      List<Survey> surveyList =
          jsonData.map((e) => Survey.fromJson(e)).toList();
      return surveyList;
    } else {
      throw Exception("Error on fetching data");
    }
  }

  Future<void> submitSurveyAnswers(
      String userId, String surveyId, Map<String, String> questionMap) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    var surveyResult = SurveyResult(
        userId: userId,
        surveyId: surveyId,
        questionMap: questionMap,
        numberOfAnswers: questionMap.length);

    final url = Uri.parse('$surveyResultServiceUrl/submit');
    var body = json.encode(surveyResult.toJson(surveyResult));

    final response = await client.post(url, body: body);

    if (response.statusCode == 201) {
      print("OK");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get survey result details');
    }
  }

  Future<Map<String, dynamic>> getDataFoCharts(String surveyId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response = await client.get(Uri.parse('$surveyResultServiceUrl/listall/$surveyId'));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);
      return jsonResult['surveyResult'];
    } else {
      throw Exception('Failed to fetch survey results');
    }
  }

  Future<SurveyResultResponse> fetchSurveyResults(
      String surveyId, String userId) async {
    final preferences = await getSharedPreferences();
    final client = AuthInterceptor(http.Client(), preferences);

    final response =
        await client.get(Uri.parse('$surveyResultServiceUrl/submitted/$surveyId/$userId'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return SurveyResultResponse.fromJson(jsonData);
    } else {
      throw Exception("Error on fetching data");
    }
  }
}

class SurveyQuestionResponse {
  final String id;
  final String text;
  final Map<String, int> responseAnswerMap;

  SurveyQuestionResponse({
    required this.id,
    required this.text,
    required this.responseAnswerMap,
  });

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionResponse(
      id: json['id'],
      text: json['text'],
      responseAnswerMap: Map<String, int>.from(json['responseAnswerMap']),
    );
  }
}
