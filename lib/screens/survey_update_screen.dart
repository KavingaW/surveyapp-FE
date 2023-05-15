import 'package:flutter/material.dart';

import 'package:surveyapp/service/survey_service.dart';
import 'package:surveyapp/model/survey_api_response.dart';

import '../utils/constants.dart';
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

  Future<void> _editSurvey() async {
    Survey _survey = Survey(
      id: widget.survey.id,
      title: _titleController.text,
      description: _descriptionController.text,
      questions: widget.survey.questions,
      assigned: widget.survey.assigned,
    );

    _surveyService.updateSurvey(TextFile.token, widget.survey.id, _survey);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Survey edited successfully')));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionAddScreen(
            survey: _survey,
          )),
    );
    // try {
    //   await SurveyService().editSurvey(editedSurvey);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Survey edited successfully')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to edit survey details')),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Survey'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         'Total Questions: $_questionCount',
              //         style: TextStyle(fontSize: 16.0),
              //       ),
              //     ),
              //     SizedBox(width: 16.0),
              //     ElevatedButton(
              //       onPressed: () {
              //         // Navigate to edit questions screen
              //       },
              //       child: Text('Edit Questions'),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 16.0),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         'Assigned Users : $_userCount',
              //         style: TextStyle(fontSize: 16.0),
              //       ),
              //     ),
              //     SizedBox(width: 16.0),
              //     ElevatedButton(
              //       onPressed: () {
              //         // Navigate to edit assigned users screen
              //       },
              //       child: Text('Edit Assigned Users'),
              //     ),
              //   ],
              // ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _editSurvey,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
