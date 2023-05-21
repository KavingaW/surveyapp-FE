import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/service/survey_service.dart';
import '../helper/validator_helper.dart';
import '../model/survey_api_model.dart';
import '../utils/constants.dart';

class AddSurveyScreen extends StatefulWidget {
  const AddSurveyScreen({super.key});

  @override
  _AddSurveyScreenState createState() => _AddSurveyScreenState();
}

class _AddSurveyScreenState extends State<AddSurveyScreen> {
  final _surveyService = SurveyService();
  final _formKey = GlobalKey<FormState>();
  String _surveyTitle = '';
  String _surveyDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.surveyAddScreenTitle),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            SizedBox(
              height: AppConstants.sizedBoxSizesHeight,
            ),
            TextFormField(
              scrollPadding: EdgeInsets.all(AppConstants.edgeInsetsValue),
              decoration: InputDecoration(
                hintText: AppConstants.hintSurveyTitle,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                return HelperValidator.validateSurveyTitle(value!);
              },
              onSaved: (value) {
                _surveyTitle = value!;
              },
            ),
            SizedBox(
              height: AppConstants.sizedBoxSizesHeight,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: AppConstants.hintSurveyDescription,
              ),
              validator: (value) {
                return HelperValidator.validateSurveyDescription(value!);
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
                    Survey createdSurvey =
                        await _surveyService.addSurvey(survey);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SurveyDetailsScreen(survey: createdSurvey)),
                    );
                  }
                },
                child: Text(AppConstants.addSurvey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
