import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:surveyapp/model/survey_api_response.dart';

class QuestionService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/question';

  Future<void> addQuestion(String token, String surveyId, Question question) async {
   //final body = json.encode({'text': question.text, 'type': question.type,'options': question.options});

    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },

      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 201) {
      print("OK");
      // Question added successfully
    } else {
      // Error adding question
    }
  }

  Future<void> updateQuestion(String token, String questionId, Question question) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$questionId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(question.questionToJson(question)),
    );

    if (response.statusCode == 200) {
      print("OK");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<String> deleteQuestion(String token, String questionId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$questionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // var jsonData = jsonDecode(response.body) as List;
      // List<User> userList = jsonData.map((e) => User.fromJson(e)).toList();

      String deleted = 'deleted';
      return deleted;
    } else {
      throw Exception("Error on fetching data");
    }
  }
}
