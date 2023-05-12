import 'dart:convert';

//import 'package:surveyapp/model/question_api_response.dart';

// class Survey {
//   final String id;
//   final String title;
//   final String description;
//   final List<Question> questions;
//   final List<String> assigned;
//
//   Survey(
//       {required this.id,
//       required this.title,
//       required this.description,
//       required this.questions,
//       required this.assigned});
//
//   factory Survey.fromJson(Map<String, dynamic> json) {
//     // var jsonData = jsonDecode(questions) as List;
//     // List<Question> questionList =
//     // jsonData.map((e) => Question.fromJson(e)).toList();
//
//     var questionList = json['questions'] as List;
//     List<Question> questions =
//         questionList.map((map) => Question.fromJson(map)).toList();
//
//     var assignedList = json['assigned'] as List;
//     List<String> assigned =
//         assignedList.map((item) => item.toString()).toList();
//
//     return Survey(
//         id: json['id'],
//         title: json['title'],
//         description: json['description'],
//         questions: questions,
//         assigned: assigned
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'description': description,
//         'questions': questions,
//         'assigned': assigned
//       };
// }

class Survey {
  String id;
  String title;
  String description;
  List<Question> questions;
  List<String> assigned;

  Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.assigned,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    var questions = json['questions'] as List;
    List<Question> questionList = questions
        .map((questionJson) => Question.fromJson(questionJson))
        .toList();

    return Survey(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: questionList,
      assigned: json['assigned'].cast<String>(),
    );
  }

  Survey copyWith({
    String? id,
    String? title,
    String? description,
    List<Question>? questions,
    List<String>? assigned,
  }) {
    return Survey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      assigned: assigned ?? this.assigned,
    );
  }
}

class Question {
  String id;
  String text;
  String type;
  List<String> options;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options:
          json['options'] != null ? List<String>.from(json['options']) : [],
    );
  }

  Map<String, dynamic> toJson() =>
      {'text': text, 'type': type, 'options': options};

  Map<String, dynamic> questionToJson(Question question) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = question.text;
    data['type'] = question.type;
    data['options'] = question.options;
    return data;
  }
}
