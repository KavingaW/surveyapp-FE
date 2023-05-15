import 'dart:convert';
import 'package:http/http.dart' as http;

class SurveyResult {
  final String userId;
  final String surveyId;
  final Map<String, dynamic> questionMap;
  final int numberOfAnswers;

  SurveyResult({
    required this.userId,
    required this.surveyId,
    required this.questionMap,
    required this.numberOfAnswers,
  });

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    return SurveyResult(
      userId: json['userId'],
      surveyId: json['surveyId'],
      questionMap: Map<String, dynamic>.from(json['questionMap']),
      numberOfAnswers: json['numberOfAnswers'],
    );
  }
}

class SurveyResultsResponse {
  final List<SurveyResult> surveyResults;
  final int respondents;

  SurveyResultsResponse({
    required this.surveyResults,
    required this.respondents,
  });

//   factory SurveyResultsResponse.fromJson(Map<String, dynamic> json) {
//     final final List<Map<String, dynamic>> surveyResults = (json['surveyResultListResponseDtoList'] as List<dynamic>)
//         .map((result) => SurveyResult.fromJson(result))
//         .toList();
//
//     return SurveyResultsResponse(
//       surveyResults: surveyResults,
//       respondents: json['respondents'],
//     );
//   }
// }
//
// final List<Map<String, dynamic>> fetchSurveyResults(String surveyId, String userId) async {
//   final response = await http.get(Uri.parse('http://localhost:8080/api/survey-result/submitted/$surveyId/$userId'));
//
//   if (response.statusCode == 200) {
//     return SurveyResultsResponse.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load survey results');
//   }
}