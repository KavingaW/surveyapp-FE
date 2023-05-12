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

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    return SurveyResult(
        userId: json['userId'],
        surveyId: json['surveyId'],
        questionMap: json['questionMap'],
        numberOfAnswers: json['numberOfAnswers']
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'surveyId': surveyId,
   'questionMap': questionMap,
    'numberOfAnswer': numberOfAnswers
  };
}