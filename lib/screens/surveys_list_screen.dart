import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';

import '../model/survey_api_model.dart';
import '../service/survey_result_service.dart';
import '../service/survey_service.dart';
import '../widgets/logout_widget.dart';
import 'add_survey_scren.dart';

class SurveyListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SurveyListScreen();
}

class _SurveyListScreen extends State<StatefulWidget> {
  late List<Survey> _surveyList;
  List<Survey> _filteredSurveyList = [];
  final _surveyService = SurveyService();
  final _surveyResultService = SurveyResultService();

  @override
  void initState() {
    super.initState();
    loadSurveys();
    _surveyList = [];
  }

  loadSurveys() async {
    await _surveyService.getSurveyList().then((surveyList) {
      setState(() {
        _surveyList = surveyList;
        _filteredSurveyList = _surveyList;
      });
    });
  }

  void filterSurveys(String searchQuery) {
    setState(() {
      _filteredSurveyList = _surveyList.where((survey) {
        final title = survey.title.toLowerCase();
        final description = survey.description.toLowerCase();
        final query = searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SurveySearchDelegate(_surveyList));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _surveyList.length,
        itemBuilder: (BuildContext context, int index) {
          Survey survey = _surveyList[index];
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.assessment,
                size: 50.0,color: Colors.cyan,
              ),
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
            ),
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

class SurveySearchDelegate extends SearchDelegate<String> {
  final List<Survey> surveyList;

  SurveySearchDelegate(this.surveyList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Implement your own search results view
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: surveyList.length,
        itemBuilder: (BuildContext context, int index) {
          final Survey survey = surveyList[index];
          return ListTile(
            leading: const Icon(Icons.assessment, size: 50.0,color: Colors.cyan),
            title: Text(
              survey.title,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              survey.description,
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () {
              close(context, '');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyDetailsScreen(survey: survey),
                ),
              );
            },
          );
        },
      );
    }

    final List<Survey> filteredList = surveyList.where((survey) {
      final title = survey.title.toLowerCase();
      final description = survey.description.toLowerCase();
      final query = this.query.toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        final Survey survey = filteredList[index];
        return ListTile(
          leading: const Icon(Icons.assessment, size: 50.0),
          title: Text(
            survey.title,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            survey.description,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () {
            close(context, '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SurveyDetailsScreen(survey: survey),
              ),
            );
          },
        );
      },
    );
  }
}
