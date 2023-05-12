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

import '../service/user_service.dart';
import 'add_question_screen.dart';

class SurveyDetailsScreen extends StatefulWidget {
  final Survey survey;

  SurveyDetailsScreen({required this.survey});

  @override
  _SurveyDetailsScreenState createState() => _SurveyDetailsScreenState();
}

class _SurveyDetailsScreenState extends State<SurveyDetailsScreen> {
  late Survey _survey;
  final _surveyService = SurveyService();

  @override
  void initState() {
    super.initState();
    _loadSurveyDetails();
  }

  void _loadSurveyDetails() async {
    // final survey = await _surveyService.getSurvey(widget.survey.id);
    final survey = widget.survey;
    setState(() {
      _survey = survey;
    });
  }

  void _editQuestion(Question question) {
    // Navigate to the question edit screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionUpdateScreen(question: question)),
    );
    // Pass the question object to the screen
    // Update the survey object with the edited question
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Details'),
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
                _updateSurvey();
              } else if (value == 'delete') {
                _deleteSurvey();
              } else if (value == 'viewAssigned') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignedUsersScreen(survey: _survey,)),
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
                              Text(
                                question.text,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
          Navigator.push(
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
