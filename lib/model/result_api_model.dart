class SurveyResult{
  String userId;
  String surveyId;
  Map<String, String> questionMap;
  int numberOfAnswers;

  SurveyResult({
    required this.userId,
    required this.surveyId,
    required this.questionMap,
    required this.numberOfAnswers
  });

  // factory SurveyResult.fromJson(Map<String, dynamic> json) {
  //   return SurveyResult(
  //       userId: json['userId'],
  //       surveyId: json['surveyId'],
  //       questionMap: json['questionMap'],
  //       numberOfAnswers: json['numberOfAnswers']
  //   );
  // }

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    var questionMap;
    if(json['questionMap'].toString() != "null"){
      questionMap = (json['questionMap'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString()));
    }

    return SurveyResult(
      userId: json['userId'].toString(),
      surveyId: json['surveyId'].toString(),
      questionMap: questionMap,
      numberOfAnswers: json['numberOfAnswers'] as int,
    );
  }

  Map<String, dynamic> toJson(SurveyResult surveyResult){

  final Map<String, dynamic> data = Map<String, dynamic>();
  data['userId'] = surveyResult.userId;
  data['surveyId'] = surveyResult.surveyId;
  data['questionMap'] = surveyResult.questionMap;

  return data;
   //  'userId': userId,
   //  'surveyId': surveyId,
   // 'questionMap': questionMap,
   //  'numberOfAnswer': numberOfAnswers
  }
}