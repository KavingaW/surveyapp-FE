import 'package:flutter/material.dart';
import 'package:surveyapp/model/user_token_response_model.dart';
import 'package:surveyapp/screens/survey_result_screen.dart';
import 'package:surveyapp/screens/survey_screen.dart';
import 'package:surveyapp/service/auth_service.dart';
import 'package:surveyapp/service/survey_result_service.dart';
import 'package:surveyapp/service/survey_service.dart';
import '../model/survey_api_model.dart';
import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';
import 'user_self_update_screen.dart';

class UserDashboard extends StatefulWidget {
  final User user;

  UserDashboard({super.key, required this.user});

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
    loadSurveys();
  }

  loadSurveys() async {
    final assignedSurveys =
        await _surveyService.getUserAssignedSurveyList(widget.user.id);

    final completedSurveys =
        await _surveyResultService.getUserCompletedSurveyList(widget.user.id);

    setState((){
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
        title: const Text('User Dashboard'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.person),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'update',
                child: Text('Update Profile'),
              ),
              const PopupMenuItem(
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
                      ConfirmationResponseMessage.show(
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
            const TabBar(
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
                  _assignedSurveys.isEmpty
                      ? const Center(
                    child: Text(
                      'No Assigned Surveys',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  :ListView.builder(
                    itemCount: _assignedSurveys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_assignedSurveys[index].title),
                          subtitle: Text(_assignedSurveys[index].description),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SurveyScreen(
                                    survey: _assignedSurveys[index],
                                    userId: widget.user.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Take Survey'),
                          ),
                        ),
                      );
                    },
                  ),

                  // Completed Surveys Tab
                  _completedSurveys.isEmpty
                      ? const Center(
                    child: Text(
                      'No Completed Surveys',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  :ListView.builder(
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
                            child: const Text('View Answers'),
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