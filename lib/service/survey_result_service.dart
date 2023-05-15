import 'dart:convert';

import 'package:surveyapp/model/results_api_response.dart';

import '../model/result_list_api_response.dart';
import 'package:http/http.dart' as http;

import '../model/survey_api_response.dart';

class SurveyResultService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/survey-result';
  late String userId;

  // Future<List<SurveyListResult>> getSurveyList() async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/$userId'),
  //     // headers: <String, String>{
  //     //   'Authorization': 'Bearer $token',
  //     // },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     var jsonData = jsonDecode(response.body) as List;
  //     List<Survey> surveyList =
  //     jsonData.map((e) => Survey.fromJson(e)).toList();
  //     return surveyList;
  //   } else {
  //     throw Exception("Error on fetching data");
  //   }
  // }

  Future<List<Survey>> getUserCompletedSurveyList(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/assigned/$userId'),
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

  Future<void> submitSurveyAnswers(String token, String userId, String surveyId,
      Map<String, String> questionMap) async {
    var surveyResult = SurveyResult(
        userId: userId,
        surveyId: surveyId,
        questionMap: questionMap,
        numberOfAnswers: questionMap.length);
    final url = Uri.parse('$baseUrl/submit');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var body = json.encode(surveyResult.toJson(surveyResult));

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print("OK");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get survey result details');
    }
  }
}
