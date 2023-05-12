import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';

import '../model/survey_api_response.dart';
import '../service/survey_service.dart';
import '../widgets/logout_widget.dart';

class SurveyListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SurveyListScreen();
}

class _SurveyListScreen extends State<StatefulWidget> {
  late List<Survey> _surveyList;
  SurveyService surveyService = new SurveyService();

  @override
  void initState() {
    super.initState();
    _surveyList = [];
    loadSurveys();
  }

  void loadSurveys() async {
    surveyService
        .getSurveyList(
            // "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2NDQ4MDVjYmVhY2NkNjJlNGJiYTQ4YzgiLCJpYXQiOjE2ODM2MDI2NjEsImV4cCI6MTY4MzY4OTA2MX0.aMdst5AmL1XaYu7Zmn1oU61LoQKuZiVmHq6sQ6BEzaQ")
            )
        .then((surveyList) {
      setState(() {
        _surveyList = surveyList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey List'),
        automaticallyImplyLeading: false,
        actions: [
          LogoutButton(onLogout: () {
            Navigator.of(context).pushNamed('/loginScreen');
          }),
        ],
      ),
      body: ListView.builder(
        itemCount: _surveyList.length,
        itemBuilder: (BuildContext context, int index) {
          Survey survey = _surveyList[index];
          return ListTile(
            title: Text(survey.title),
            subtitle: Text(survey.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyDetailsScreen(survey: survey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Surveys'),
//     ),
//     body: Container(
//       child: Center(
//         child: Text('Survey data will be displayed here'),
//       ),
//     ),
//   );
// }
// }
