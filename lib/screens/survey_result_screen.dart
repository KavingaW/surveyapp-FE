import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:surveyapp/service/survey_result_service.dart';
import 'package:surveyapp/utils/constants.dart';
import '../model/survey_result.dart';

class SurveyResultScreen extends StatefulWidget {
  final String surveyId;
  final String userId;

  SurveyResultScreen({super.key, required this.surveyId, required this.userId});

  @override
  _SurveyResultScreenState createState() => _SurveyResultScreenState();
}

class _SurveyResultScreenState extends State<SurveyResultScreen> {
  late Future<SurveyResultResponse> _surveyResponse;
  final _surveyResultService = SurveyResultService();

  @override
  void initState() {
    super.initState();
    _surveyResponse =
        _surveyResultService.fetchSurveyResults(widget.surveyId, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.surveyResponseDetails),
      ),
      body: FutureBuilder<SurveyResultResponse>(
        future: _surveyResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final surveyData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.blue,
                            child: Image.asset(
                              'assets/images/user-surevy-result.png',
                              scale: 5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            surveyData.surveyName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            surveyData.surveyDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Question Responses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: surveyData.questionMap.length,
                      itemBuilder: (context, index) {
                        final question =
                            surveyData.questionMap.keys.elementAt(index);
                        int number = index + 1;
                        final answer = surveyData.questionMap[question];
                        return Card(
                          child: ListTile(
                            title: Text(
                              '$number. $question',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Answer Submitted:',
                                ),
                                Text(
                                  answer!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Number of Answers: ${surveyData.numberOfAnswers}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
