import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';

import '../model/survey_api_response.dart';
import '../service/survey_result_service.dart';
import '../service/survey_service.dart';
import '../widgets/logout_widget.dart';
import 'add_new_survey_scren.dart';

class SurveyListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SurveyListScreen();
}

class _SurveyListScreen extends State<StatefulWidget> {
  late List<Survey> _surveyList;
  SurveyService surveyService = SurveyService();
  final _surveyResultService = SurveyResultService();

  @override
  void initState() {
    super.initState();
    loadSurveys();
    _surveyList = [];
  }

  loadSurveys() async {
   await surveyService.getSurveyList().then((surveyList) {
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
        // automaticallyImplyLeading: false,
        // actions: [
        //   LogoutButton(onLogout: () {
        //     Navigator.of(context).pushNamed('/loginScreen');
        //   }),
        // ],
      ),
      body: ListView.builder(
        itemCount: _surveyList.length,
        itemBuilder: (BuildContext context, int index) {
          Survey survey = _surveyList[index];
          return ListTile(
            leading: Icon(Icons.assessment,size:50.0 ,),
            title: Text(survey.title),
            subtitle: Text(survey.description),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyDetailsScreen(survey: survey),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddSurveyScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
