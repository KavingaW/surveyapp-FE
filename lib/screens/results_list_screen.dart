import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:surveyapp/service/survey_result_service.dart';

class ResultsListScreen extends StatefulWidget {
  @override
  _ResultsListScreenState createState() => _ResultsListScreenState();
}

class _ResultsListScreenState extends State<ResultsListScreen> {
  SurveyResultService _surveyResultService = SurveyResultService();
  List surveyResults = [];

  @override
  void initState() {
    super.initState();
    fetchSurveyResults();
  }

  void fetchSurveyResults() async {
     var response = await http.get(Uri.parse('http://10.0.2.2:8080/api/survey-result/list'));
     var data = json.decode(response.body);

    setState(() {
      surveyResults = data['surveyResultListResponseDtoList'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Results'),
      ),
      body: ListView.builder(
        itemCount: surveyResults.length,
        itemBuilder: (BuildContext context, int index) {
          var surveyResult = surveyResults[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SurveyResultDetailsScreen(surveyResult: surveyResult),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(surveyResult['surveyName']),
                subtitle: Text(surveyResult['surveyDescription']),
                trailing: Text('${surveyResult['numberOfAnswers']} Respondents'),
              ),
            ),
          );
        },
      ),
    );
  }
}


class SurveyResultDetailsScreen extends StatelessWidget {
  final surveyResult;

  SurveyResultDetailsScreen({this.surveyResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surveyResult['surveyName']),
      ),
      body: ListView.builder(
        itemCount: surveyResult['questionMap'].length,
        itemBuilder: (BuildContext context, int index) {
          var question = surveyResult['questionMap'].keys.toList()[index];
          var answer = surveyResult['questionMap'].values.toList()[index];
          return Card(
            child: ListTile(
              title: Text(question),
              subtitle: Text(answer),
            ),
          );
        },
      ),
    );
  }
}
