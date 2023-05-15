// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:surveyapp/service/survey_result_service.dart';
//
// class SurveyResultScreen extends StatefulWidget {
//   final String surveyId;
//
//   SurveyResultScreen({required this.surveyId});
//
//   @override
//   _SurveyResultScreenState createState() => _SurveyResultScreenState();
// }
//
// class _SurveyResultScreenState extends State<SurveyResultScreen> {
//
//   SurveyResultService surveyResultService = SurveyResultService();
//   List _surveyResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     //_getSurveyResults();
//   }
//
//   Future<void> _getSurveyResults() async {
//     final response = await http.get(Uri.parse(
//         'https://your-api-url.com/survey-results/${widget.surveyId}'));
//     final data = json.decode(response.body);
//     setState(() {
//       _surveyResults = data['surveyResultListResponseDtoList'];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Results'),
//       ),
//       body: _surveyResults.isEmpty
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : ListView.builder(
//         itemCount: _surveyResults.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Card(
//             margin: EdgeInsets.all(10.0),
//             child: InkWell(
//               onTap: () {
//                 // TODO: Navigate to a details screen for this survey result
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'User: ${_surveyResults[index]['userId']}',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                       'Number of Answers: ${_surveyResults[index]['numberOfAnswers']}',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// import '../model/results_api_response.dart';
//
//
// class SurveyResultScreen extends StatelessWidget {
//   final String surveyId;
//   final SurveyResult surveyResult;
//   const SurveyResultScreen({Key? key, required this.surveyId, required this.surveyResult}) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Results'),
//       ),
//       body: ListView.builder(
//         itemCount: surveyResult.questionMap.length,
//         itemBuilder: (context, index) {
//           final question = surveyResult.questionMap.keys.elementAt(index);
//           final answer = surveyResult.questionMap.values.elementAt(index);
//           return ListTile(
//             title: Text(question),
//             subtitle: Text(answer),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../model/results_api_response.dart';
//
// class SurveyResultScreen extends StatefulWidget {
//   final String surveyId;
//   final String userId;
//
//   SurveyResultScreen({required this.surveyId, required this.userId});
//
//   @override
//   _SurveyResultScreenState createState() => _SurveyResultScreenState();
// }
//
// class _SurveyResultScreenState extends State<SurveyResultScreen> {
//   late Future<Map<String, dynamic>> _surveyResultsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _surveyResultsFuture = _fetchSurveyResults();
//   }
//
//   Future<Map<String, dynamic>> _fetchSurveyResults() async {
//     final response = await http.get(Uri.parse(
//         'http://10.0.2.2:8080/api/survey-result/submitted/${widget.surveyId}/${widget.userId}'));
//     if(response.statusCode == 200){
//       var responseData = json.decode(response.body);
//       Future<Map<String, dynamic>> surveyList =
//       responseData.map((e) => SurveyResult.fromJson(e));
//       return surveyList;
//     }
//     else {
//       throw Exception("Error on fetching data");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Results'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _surveyResultsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('An error occurred while fetching survey results.'),
//             );
//           }
//           final surveyResults = snapshot.data!['surveyResultListResponseDtoList'];
//           final respondents = snapshot.data!['respondents'];
//           return Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Survey Results - ${surveyResults.length} Respondent(s)',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: surveyResults.length,
//                     itemBuilder: (context, index) {
//                       final result = surveyResults[index];
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Respondent ${index + 1}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8.0),
//                           Text(
//                             'Number of answers: ${result['numberOfAnswers']}',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           SizedBox(height: 8.0),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: result['questionMap'].entries.map((entry) {
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 4.0),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       '${entry.key}:',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(width: 8.0),
//                                     Text(entry.value.toString()),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                           Divider(thickness: 1.0),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../service/test_service.dart';

class SurveyResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> surveyResultList;
  final int respondents;
  final String surveyId;
  final String userId;

  const SurveyResultScreen({
    Key? key,
    required this.surveyResultList,
    required this.respondents,
    required this.surveyId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Results'),
      ),
      body: ListView.builder(
        itemCount: surveyResultList.length,
        itemBuilder: (BuildContext context, int index) {
          final surveyResult = surveyResultList[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Survey ID: ${surveyResult['surveyId']}'),
                  Text('Number of Answers: ${surveyResult['numberOfAnswers']}'),
                  SizedBox(height: 16),
                  Text('Answers:'),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final entry in surveyResult['questionMap'].entries)
                        ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Total Respondents: $respondents'),
        ),
      ),
    );
  }
}
