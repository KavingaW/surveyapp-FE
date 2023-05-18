// import 'package:flutter/material.dart';
// import 'package:surveyapp/model/survey_api_response.dart';
//
// class SurveyDetailsScreen extends StatelessWidget{
//
//   final Survey survey;
//
//   SurveyDetailsScreen({required this.survey});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text( survey.title +' Survey Details'),
//       ),
//       body: Container(
//         child: Center(
//           child: Text('Survey details data will be displayed here'),
//         ),
//       ),
//     );
//   }

import 'package:flutter/material.dart';
import 'package:surveyapp/screens/question_update_screen.dart';
import 'package:surveyapp/screens/survey_assigned_users_screen.dart';
import 'package:surveyapp/screens/survey_update_screen.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/service/survey_result_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/survey_api_response.dart';

// class SurveyDetailsScreen extends StatelessWidget {
//   final Survey survey;
//
//   const SurveyDetailsScreen({Key? key, required this.survey}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Title: ${survey.title}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Description: ${survey.description}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Questions:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Column(
//                 children: survey.questions
//                     .map((question) =>
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '${question.question}',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Answers:',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: question.answers
//                               .map((answer) =>
//                               Text(
//                                 '${answer.answer}',
//                                 style: TextStyle(fontSize: 16),
//                               ))
//                               .toList(),
//                         ),
//                         SizedBox(height: 20),
//                       ],
//                     ))
//                     .toList(),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Assigned Users:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: survey.assignedUsers
//                     .map((user) =>
//                     Text(
//                       '- ${user.username} (${user.email})',
//                       style: TextStyle(fontSize: 16),
//                     ))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// }

import 'package:surveyapp/service/survey_service.dart';

import '../service/question_service.dart';
import '../service/user_service.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';
import 'add_question_screen.dart';

class SurveyDetailsScreen extends StatefulWidget {
  final Survey survey;

  SurveyDetailsScreen({required this.survey});

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
    _loadSurveyDetails();
  }

  _loadSurveyDetails() async {
    // final survey = widget.survey;
    final survey = await _surveyService.getSurvey(widget.survey.id);
    setState(() {
      _survey = survey;
    });
  }

  void _editQuestion(Question question) {
    // Navigate to the question edit screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionUpdateScreen(question: question)),
    );
    // Pass the question object to the screen
    // Update the survey object with the edited question
  }

  _deleteQuestion(String questionId, Survey survey) async {
    await _questionService.deleteQuestion(questionId);
  }

  _deleteSurvey(String token, String surveyId, BuildContext context) async {
    await _surveyService.deleteSurvey(surveyId, context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when the button is pressed
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              PopupMenuItem(
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
                      await _deleteSurvey(
                          AppConstants.token, widget.survey.id, context);
                      DeleteResponseMessage.show(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _survey.title,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _survey.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        onTap: () => _editQuestion(question),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    question.text,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => ConfirmationDialog(
                                        onConfirm: () async {
                                          await _deleteQuestion(
                                              question.id, _survey);
                                          DeleteResponseMessage.show(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Assigned Users',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_survey.assigned.join(', ')),
                  ),
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

_deleteSurvey() {}

void _updateSurvey() {}

void _addQuestion() {}
