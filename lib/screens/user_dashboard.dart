import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/model/user_token_response.dart';
import 'package:surveyapp/screens/survey_result_screen.dart';
import 'package:surveyapp/screens/survey_screen.dart';
import 'package:surveyapp/screens/user_update_screen.dart';
import 'package:surveyapp/service/auth_service.dart';
import 'package:surveyapp/service/survey_result_service.dart';
import 'package:surveyapp/service/survey_service.dart';

import '../model/survey_api_response.dart';

import 'package:flutter/material.dart';

import '../service/test_service.dart';
import '../utils/constants.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';
import 'edit_user_details.dart';

class UserDashboard extends StatefulWidget {
  final User user;

  UserDashboard({required this.user});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _surveyService = SurveyService();
  final _authService = AuthService();
  final _surveyResultService = SurveyResultService();
  List<Survey> _assignedSurveys = [];
  List<Survey> _completedSurveys = [];

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  void _loadSurveys() async {
    final assignedSurveys =
        await _surveyService.getUserAssignedSurveyList(widget.user.id);

    final completedSurveys =
        await _surveyResultService.getUserCompletedSurveyList(widget.user.id);

    setState(() {
      // Filter out surveys that are in both lists
      _assignedSurveys = assignedSurveys
          .where((assignedSurvey) => completedSurveys.every((completedSurvey) =>
              completedSurvey.title != assignedSurvey.title))
          .toList();
      _completedSurveys = completedSurveys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.person),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'update',
                child: Text('Update'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'update') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditUserScreen(
                            userId: widget.user.id,
                          )),
                );
                // _updateSurvey();
              } else if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    onConfirm: () async {
                      //userService.deleteUser(TextFile.token, widget.user.id);
                      DeleteResponseMessage.show(
                        context,
                        'Successfully logged out.',
                      );

                      Navigator.pop(context);
                      _authService.logOut();
                      Navigator.pushReplacementNamed(context, '/loginScreen');
                    },
                    operation: AppConstants.operationLogout,
                    message: AppConstants.messageLogout,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              indicatorWeight: 4.0,
              tabs: [
                Tab(
                  text: 'Assigned Surveys',
                ),
                Tab(text: 'Completed Surveys'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Assigned Surveys Tab
                  ListView.builder(
                    itemCount: _assignedSurveys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_assignedSurveys[index].title),
                          subtitle: Text(_assignedSurveys[index].description),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SurveyScreen(
                                    survey: _assignedSurveys[index],
                                    userId: widget.user.id,
                                  ),
                                ),
                              );
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => SurveyForm(
                              //         questions: _assignedSurveys[index].questions),
                              //   ),
                              // );
                            },
                            child: Text('Take Survey'),
                          ),
                        ),
                      );
                    },
                  ),

                  // Completed Surveys Tab
                  ListView.builder(
                    itemCount: _completedSurveys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_completedSurveys[index].title),
                          subtitle: Text(_completedSurveys[index].description),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _surveyResultService
                                  .getUserCompletedSurveyList(widget.user.id);

                              // Navigator.pushNamed(
                              //   context,
                              //   '/survey-results',
                              //   arguments: _completedSurveys[index],
                              // );

                              // final List<Map<String, dynamic>> surveyResultList
                              // =fetchSurveyResults(_completedSurveys[index].id,widget.user.id);
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //       builder: (context) => SurveyResultScreen(
                              //           surveyResultList: surveyResultList,
                              //           respondents: 5,
                              //           surveyId: _completedSurveys[index].id,
                              //           userId: widget.user.id)),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurveyResultScreen(
                                    surveyId: _completedSurveys[index].id,
                                    userId: widget.user.id,
                                  ),
                                ),
                              );
                            },
                            child: Text('View Answers'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../model/survey_api_response.dart';
// import '../service/survey_service.dart';
//
// class UserDashboard extends StatefulWidget {
//   final User user;
//
//   UserDashboard({required this.user});
//
//   @override
//   _UserDashboardState createState() => _UserDashboardState();
// }
//
// class _UserDashboardState extends State<UserDashboard> {
//   final _surveyService = SurveyService();
//   final _surveyResulService = SurveyResultService();
//   List<Survey> _assignedSurveys = [];
//   List<Survey> _completedSurveys = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSurveys();
//   }
//
//   void _loadSurveys() async {
//     final assignedSurveys =
//         await _surveyService.getUserAssignedSurveyList(widget.user.id);
//     final completedSurveys =
//         await _surveyResulService.getUserCompletedSurveyList(widget.user.id);
//
//     setState(() {
//       // Filter out surveys that are in both lists
//       _completedSurveys = completedSurveys
//           .where((completedSurvey) => assignedSurveys.every(
//               (assignedSurvey) => assignedSurvey.id != completedSurvey.id))
//           .toList();
//
//       _assignedSurveys = assignedSurveys;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Dashboard'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Assigned Surveys',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                 itemCount: _assignedSurveys.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                     child: ListTile(
//                       title: Text(_assignedSurveys[index].title),
//                       subtitle: Text('Assigned'),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Completed Surveys',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                 itemCount: _completedSurveys.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                     child: ListTile(
//                       title: Text(_completedSurveys[index].title),
//                       subtitle: Text('Completed'),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
