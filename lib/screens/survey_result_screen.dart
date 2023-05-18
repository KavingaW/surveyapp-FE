import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/survey_result.dart';

class SurveyResultScreen extends StatefulWidget {
  final String surveyId;
  final String userId;

  SurveyResultScreen({super.key, required this.surveyId, required this.userId});

  @override
  _SurveyResultScreenState createState() => _SurveyResultScreenState();
}

class _SurveyResultScreenState extends State<SurveyResultScreen> {
  late Future<SurveyResultResponse> surveyResponse;

  @override
  void initState() {
    super.initState();
    surveyResponse = _fetchSurveyResults();
  }

  Future<SurveyResultResponse> _fetchSurveyResults() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/survey-result/submitted/${widget.surveyId}/${widget.userId}'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return SurveyResultResponse.fromJson(jsonData);
    } else {
      throw Exception("Error on fetching data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Response Details'),
      ),
      body: FutureBuilder<SurveyResultResponse>(
        future: surveyResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final surveyData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Survey Name: ${surveyData.surveyName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Survey Description: ${surveyData.surveyDescription}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Question Responses:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: surveyData.questionMap.length,
                    itemBuilder: (context, index) {
                      final question =
                          surveyData.questionMap.keys.elementAt(index);
                      final answer = surveyData.questionMap[question];
                      return ListTile(
                        title: Text(
                          question,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(answer!),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Number of Answers: ${surveyData.numberOfAnswers}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
