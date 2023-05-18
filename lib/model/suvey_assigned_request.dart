


import 'package:surveyapp/model/survey_api_response.dart';
import 'package:surveyapp/model/user_admin_response.dart';

class SurveyAssignedUsers {
  String id;
  String title;
  String description;
  List<Question> questions;
  List<UserAssigned> assigned;

  SurveyAssignedUsers({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.assigned,
  });

  static Map<String, dynamic> surveyToJson(SurveyAssignedUsers survey) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = survey.title;
    data['description'] = survey.description;
    data['questions'] = survey.questions;
    data['assigned'] = survey.assigned;
    return data;
  }

  factory SurveyAssignedUsers.fromJson(Map<String, dynamic> json) {
    List<Question> questionList = [];
    List<UserAssigned> userList = [];
    if (json['questions'].toString() != "null") {
      var questions = json['questions'] as List;
      questionList = questions
          .map((questionJson) => Question.fromJson(questionJson))
          .toList();
    }
    if (json['assigned'].toString() != "null") {
      var users = json['assigned'] as List;
      userList =
          users.map((userJson) => UserAssigned.fromJson(userJson)).toList();
    }
    return SurveyAssignedUsers(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: questionList,
      assigned: userList,
    );
  }
}

class UserAssigned {
  String id;

  UserAssigned({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  factory UserAssigned.fromJson(Map<String, dynamic> json) {
    return UserAssigned(id: json['id']);
  }
}
