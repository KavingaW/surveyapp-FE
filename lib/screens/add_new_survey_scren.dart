import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/service/survey_service.dart';

import '../model/survey_api_response.dart';
import '../utils/constants.dart';

class AddSurveyScreen extends StatefulWidget {
  @override
  _AddSurveyScreenState createState() => _AddSurveyScreenState();
}

class _AddSurveyScreenState extends State<AddSurveyScreen> {
  SurveyService _surveyService = SurveyService();
  final _formKey = GlobalKey<FormState>();
  String _surveyTitle = '';
  String _surveyDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Survey'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              scrollPadding: EdgeInsets.all(20.0),
              decoration: InputDecoration(
                hintText: 'Enter survey title',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter survey title';
                }
                return null;
              },
              onSaved: (value) {
                _surveyTitle = value!;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter survey description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter survey description';
                }
                return null;
              },
              onSaved: (value) {
                _surveyDescription = value!;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    Survey survey = Survey(
                        id: "",
                        title: _surveyTitle,
                        description: _surveyDescription,
                        questions: [],
                        assigned: []);
                    Survey _createdSurvey = await  _surveyService.addSurvey(TextFile.token, survey);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SurveyDetailsScreen(survey: _createdSurvey)),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
