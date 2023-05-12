import 'package:surveyapp/model/results_api_response.dart';

class SurveyListResult{

  List<SurveyResult> surveyResultList;
  int respondents;

  SurveyListResult({
    required this.surveyResultList,
    required this.respondents
  });

  factory SurveyListResult.fromJson(Map<String, dynamic> json) {

    var resultList = json['surveyResultList'] as List;
    List<SurveyResult> surveyResults =
    resultList.map((map) => SurveyResult.fromJson(map)).toList();

    return SurveyListResult(
      surveyResultList: json['userId'],
        respondents: json['surveyId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'surveyResultList': surveyResultList,
    'respondents': respondents,
  };
}