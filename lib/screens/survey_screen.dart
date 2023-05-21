import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyapp/screens/user_dashboard.dart';
import 'package:surveyapp/service/user_service.dart';
import 'package:surveyapp/model/user_token_response_model.dart';
import '../model/user_admin_response_model.dart' as userAdmin;
import '../model/survey_api_model.dart';
import '../service/survey_result_service.dart';
import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';

class SurveyScreen extends StatefulWidget {
  final Survey survey;
  final String userId;

  SurveyScreen({super.key, required this.survey, required this.userId});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  SurveyResultService surveyResultService = SurveyResultService();
  final _userService = UserService();

  Map<String, String> _answers = {};

  @override
  void initState() {
    super.initState();
  }

  void selectOption(String questionId, String option) {
    setState(() {
      _answers[questionId] = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take Survey"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.survey.title,
              style: const TextStyle(fontSize: 30.0),
            ),
            Text(
              widget.survey.description,
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            ...widget.survey.questions.map((question) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(question.text,
                          style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 8.0),
                      ...question.options.map((option) {
                        return RadioListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          title: Text(option),
                          value: option,
                          groupValue: _answers[question.id],
                          onChanged: (value) =>
                              selectOption(question.id, value!),
                        );
                      }),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    onConfirm: () async {
                      //userService.deleteUser(TextFile.token, widget.user.id);
                      ConfirmationResponseMessage.show(
                        context,
                        'Response Submitted.',
                      );
                      await surveyResultService.submitSurveyAnswers(
                          widget.userId, widget.survey.id, _answers);

                      userAdmin.User user =
                          await _userService.getLoggedInUserDetails(widget.userId);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString(AppConstants.token);

                      User userToken = User(
                          id: user.id,
                          username: user.username,
                          email: user.email,
                          tokenType: 'Bearer',
                          role: 'user',
                          accessToken: token.toString());

                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDashboard(user: userToken),
                        ),
                      );
                    },
                    operation: AppConstants.operationSubmitResponse,
                    message: AppConstants.messageSubmitResponse,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
