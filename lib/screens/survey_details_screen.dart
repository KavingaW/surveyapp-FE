import 'package:flutter/material.dart';
import 'package:surveyapp/screens/question_update_screen.dart';
import 'package:surveyapp/screens/survey_assigned_users_screen.dart';
import 'package:surveyapp/screens/survey_update_screen.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/utils/constants.dart';
import '../model/survey_api_model.dart';
import 'package:surveyapp/service/survey_service.dart';
import '../service/question_service.dart';
import '../service/user_service.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';
import 'add_question_screen.dart';

class SurveyDetailsScreen extends StatefulWidget {
  final Survey survey;

  SurveyDetailsScreen({super.key, required this.survey});

  @override
  _SurveyDetailsScreenState createState() => _SurveyDetailsScreenState();
}

class _SurveyDetailsScreenState extends State<SurveyDetailsScreen> {
  late Survey _survey = Survey.empty();
  final _surveyService = SurveyService();
  final _questionService = QuestionService();

  @override
  void initState() {
    super.initState();
    loadSurveyDetails();
  }

  loadSurveyDetails() async {
    final survey = await _surveyService.getSurvey(widget.survey.id);
    setState(() {
      _survey = survey;
    });
  }

  void editQuestion(Question question) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionUpdateScreen(question: question)),
    );
  }

  deleteQuestion(String questionId, Survey survey) async {
    await _questionService.deleteQuestion(questionId);
  }

  deleteSurvey(String token, String surveyId, BuildContext context) async {
    await _surveyService.deleteSurvey(surveyId, context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.surveyDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when the button is pressed
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'viewAssigned',
                child: Text('View Assigned Users'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditSurveyScreen(survey: widget.survey),
                  ),
                );
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    onConfirm: () async {
                      await deleteSurvey(
                          AppConstants.token, widget.survey.id, context);
                      ConfirmationResponseMessage.show(
                        context,
                        'Survey has been deleted successfully.',
                      );
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyListScreen(),
                          ));
                    },
                    operation: AppConstants.operationDelete,
                    message: AppConstants.messageDelete,
                  ),
                );

                //_deleteSurvey(TextFile.token, widget.survey.id, context);
              } else if (value == 'viewAssigned') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssignedUsersScreen(
                            survey: _survey,
                          )),
                );
              }
            },
          ),
        ],
      ),
      body: _survey == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: const Icon(
                      Icons.assessment,
                      color: Colors.cyan,
                      size: 120.0,
                    ),
                  ),
                  SizedBox(
                    height: AppConstants.sizedBoxSizesHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _survey.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _survey.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Questions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._survey.questions.map((question) {
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () => editQuestion(question),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      question.text,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => ConfirmationDialog(
                                        onConfirm: () async {
                                          await deleteQuestion(
                                              question.id, _survey);
                                          ConfirmationResponseMessage.show(
                                            context,
                                            'Question has been deleted successfully.',
                                          );
                                          // setState(() {});
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SurveyDetailsScreen(
                                                        survey: _survey),
                                              ));
                                        },
                                        operation: AppConstants.operationDelete,
                                        message: AppConstants.messageDelete,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                                width: width,
                              ),
                              if (question.type == 'MCQ')
                                ...question.options.map((option) {
                                  return Text('- $option');
                                }),
                              if (question.type == 'YES/NO')
                                ...question.options.map((option) {
                                  return Text(
                                      '- ${option == 'Yes' ? 'Yes' : 'No'}');
                                }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 16),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionAddScreen(
                      survey: _survey,
                    )),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
