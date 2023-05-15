import 'package:flutter/material.dart';

import '../model/survey_api_response.dart';
import '../service/survey_result_service.dart';
import '../utils/constants.dart';

class SurveyScreen extends StatefulWidget {
  final Survey survey;
  final String userId;

  SurveyScreen({required this.survey, required this.userId});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {

  SurveyResultService surveyResultService = SurveyResultService();

  Map<String, String> _answers = {};

  @override
  void initState() {
    super.initState();
  }

  void _selectOption(String questionId, String option) {
    setState(() {
      _answers[questionId] = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.survey.description,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            ...widget.survey.questions.map((question) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(question.text, style: TextStyle(fontSize: 18.0)),
                      SizedBox(height: 8.0),
                      ...question.options.map((option) {
                        return RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          title: Text(option),
                          value: option,
                          groupValue: _answers[question.id],
                          onChanged: (value) =>
                              _selectOption(question.id, value!),
                        );
                      }),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () {
                surveyResultService.submitSurveyAnswers(
                    TextFile.token, widget.userId, widget.survey.id, _answers);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
