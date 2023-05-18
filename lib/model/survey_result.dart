class SurveyResultResponse {
  String userId;
  String surveyId;
  String surveyName;
  String surveyDescription;
  Map<String, String> questionMap;
  int numberOfAnswers;

  SurveyResultResponse(
      {required this.userId,
      required this.surveyId,
      required this.surveyName,
      required this.surveyDescription,
      required this.questionMap,
      required this.numberOfAnswers});

  factory SurveyResultResponse.fromJson(Map<String, dynamic> json) {
    final questionMap = (json['questionMap'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value.toString()));
    return SurveyResultResponse(
      userId: json['userId'].toString(),
      surveyId: json['surveyId'].toString(),
      surveyName: json['surveyName'].toString(),
      surveyDescription: json['surveyDescription'].toString(),
      questionMap: questionMap,
      numberOfAnswers: json['numberOfAnswers'] as int,
    );
  }

  Map<String, dynamic> toJson(SurveyResultResponse surveyResult) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = surveyResult.userId;
    data['surveyId'] = surveyResult.surveyId;
    data['surveyName'] = surveyResult.surveyName;
    data['surveyDescription'] = surveyResult.surveyDescription;
    data['questionMap'] = surveyResult.questionMap;

    return data;
    //  'userId': userId,
    //  'surveyId': surveyId,
    // 'questionMap': questionMap,
    //  'numberOfAnswer': numberOfAnswers
  }
}
