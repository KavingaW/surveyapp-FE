import 'package:flutter/material.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';

import 'package:surveyapp/service/survey_service.dart';
import 'package:surveyapp/model/survey_api_model.dart';

import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';
import 'add_question_screen.dart';

class EditSurveyScreen extends StatefulWidget {
  final Survey survey;

  EditSurveyScreen({required this.survey});

  @override
  _EditSurveyScreenState createState() => _EditSurveyScreenState();
}

class _EditSurveyScreenState extends State<EditSurveyScreen> {
  SurveyService _surveyService = SurveyService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int _questionCount = 0;
  int _userCount = 0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.survey.title;
    _descriptionController.text = widget.survey.description;
    _questionCount = widget.survey.questions.length;
    _userCount = widget.survey.assigned.length;
  }

  Future<void> editSurvey() async {
    Survey survey = Survey(
      id: widget.survey.id,
      title: _titleController.text,
      description: _descriptionController.text,
      questions: widget.survey.questions,
      assigned: widget.survey.assigned,
    );

    await _surveyService.updateSurvey(widget.survey.id, survey);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Survey edited successfully')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SurveyListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Survey'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.assessment, color: Colors.cyan, size: 120.0,),
              SizedBox(
                height: AppConstants.sizedBoxSizesHeight,
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                // onPressed: _editSurvey,
                onPressed: () {
                  editSurvey();
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
