// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// import 'package:flutter/material.dart';
// import 'package:surveyapp/service/survey_result_service.dart';
// import 'package:surveyapp/service/survey_service.dart';
//
// class SurveyResultsDetailsScreen extends StatefulWidget {
//
//
//   SurveyResultsDetailsScreen();
//
//   @override
//   _SurveyResultsDetailsScreenState createState() =>
//       _SurveyResultsDetailsScreenState();
// }
//
// class _SurveyResultsDetailsScreenState
//     extends State<SurveyResultsDetailsScreen> {
//   final SurveyResultService _surveyService = SurveyResultService();
//   Future<Map<String, dynamic>>? _surveyResult;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSurveyResult();
//   }
//
//   Future<void> _fetchSurveyResult() async {
//     _surveyResult = _surveyService.getDataFoCharts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Results Details'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _surveyResult,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Failed to fetch survey result'));
//           } else if (snapshot.hasData) {
//             final surveyResult = snapshot.data!;
//
//             return ListView.builder(
//               itemCount: surveyResult['questionResponse'].length,
//               itemBuilder: (context, index) {
//                 final questionResponse =
//                 surveyResult['questionResponse'][index];
//
//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           questionResponse['text'],
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Container(
//                           height: 300,
//                           child: SurveyChart(surveyResult: surveyResult),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No survey result found'));
//           }
//         },
//       ),
//     );
//   }
// }
//
//
// class SurveyChart extends StatelessWidget {
//   final Map<String, dynamic> surveyResult;
//
//   SurveyChart({required this.surveyResult});
//
//   // List<charts.Series<_ResponseData, String>> _createChartSeries() {
//   //   final questionResponse = surveyResult['questionResponse'];
//   //
//   //   return questionResponse.map((response) {
//   //     final responseAnswerMap = response['responseAnswerMap'];
//   //     final responseDataList = responseAnswerMap.entries.map((entry) {
//   //       final percentage = entry.value / surveyResult['totResponses'] * 100;
//   //       return _ResponseData(entry.key, percentage);
//   //     }).toList();
//   //
//   //     return charts.Series<_ResponseData, String>(
//   //       id: response['id'],
//   //       domainFn: (_ResponseData data, _) => data.answer,
//   //       measureFn: (_ResponseData data, _) => data.percentage,
//   //       data: responseDataList,
//   //     );
//   //   }).toList();
//   // }
//
//   // List<charts.Series<_ResponseData, String>> _createChartSeries() {
//   //   final questionResponse = surveyResult['questionResponse'];
//   //
//   //   return questionResponse.map<charts.Series<_ResponseData, String>>((response) {
//   //     final responseAnswerMap = response['responseAnswerMap'];
//   //     final responseDataList = responseAnswerMap.entries.map((entry) {
//   //       final percentage =
//   //           entry.value / surveyResult['totResponses'] * 100;
//   //       return _ResponseData(entry.key, percentage);
//   //     }).toList();
//   //
//   //     return charts.Series<_ResponseData, String>(
//   //       id: response['id'],
//   //       domainFn: (_ResponseData data, _) => data.answer,
//   //       measureFn: (_ResponseData data, _) => data.percentage,
//   //       data: responseDataList,
//   //     );
//   //   }).toList();
//   // }
//
//   List<charts.Series<_ResponseData, String>> _createChartSeries() {
//     final questionResponse = surveyResult['questionResponse'];
//
//     return questionResponse.map<charts.Series<_ResponseData, String>>((response) {
//       final responseAnswerMap = response['responseAnswerMap'];
//       final responseDataList = responseAnswerMap.entries.map<_ResponseData>((entry) {
//         final percentage =
//             entry.value / surveyResult['totResponses'] * 100;
//         return _ResponseData(entry.key, percentage);
//       }).toList();
//
//       return charts.Series<_ResponseData, String>(
//         id: response['id'],
//         domainFn: (_ResponseData data, _) => data.answer,
//         measureFn: (_ResponseData data, _) => data.percentage,
//         data: responseDataList.cast<_ResponseData>(), // Cast responseDataList to List<_ResponseData>
//       );
//     }).toList();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return charts.PieChart(
//       _createChartSeries(),
//       animate: true,
//       animationDuration: Duration(milliseconds: 500),
//       defaultRenderer: charts.ArcRendererConfig(
//         arcRendererDecorators: [
//           charts.ArcLabelDecorator(
//             labelPosition: charts.ArcLabelPosition.auto,
//           ),
//         ],
//       ),
//       behaviors: [
//         charts.ChartTitle(
//           'Total Responses: ${surveyResult['totResponses']}',
//           behaviorPosition: charts.BehaviorPosition.bottom,
//           titleStyleSpec: charts.TextStyleSpec(
//             fontSize: 14,
//             color: charts.MaterialPalette.black,
//           ),
//           titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
//         ),
//       ],
//     );
//   }
// }
//
// class _ResponseData {
//   final String answer;
//   final double percentage;
//
//   _ResponseData(this.answer, this.percentage);
// }

// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// import '../service/survey_result_service.dart';
//
// class SurveySummaryScreen extends StatefulWidget {
//   @override
//   _SurveySummaryScreenState createState() => _SurveySummaryScreenState();
// }
//
// class _SurveySummaryScreenState extends State<SurveySummaryScreen> {
//   List<SurveyResponse>? surveyResponses;
//   var surveyResult;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSurveyResults();
//   }
//
//   Future<void> _fetchSurveyResults() async {
//     try {
//       final data = await SurveyResultService.getDataFoCharts();
//       surveyResult = data['surveyResult'];
//
//       List<dynamic> questionResponses = surveyResult['questionResponse'];
//       surveyResponses = questionResponses
//           .map((response) => SurveyResponse(
//         id: response['id'],
//         text: response['text'],
//         responseAnswerMap: Map<String, int>.from(
//             response['responseAnswerMap']),
//       ))
//           .toList();
//
//       setState(() {});
//     } catch (error) {
//       print('Error fetching survey results: $error');
//     }
//   }
//
//   List<charts.Series<_ResponseData, String>>? _createChartSeries() {
//     return surveyResponses?.map<charts.Series<_ResponseData, String>>(
//           (response) {
//         final responseDataList = response.responseAnswerMap.entries.map(
//               (entry) {
//             final percentage =
//                 entry.value / surveyResult['totResponses'] * 100;
//             return _ResponseData(entry.key, percentage);
//           },
//         ).toList();
//
//         return charts.Series<_ResponseData, String>(
//           id: response.id,
//           domainFn: (_ResponseData data, _) => data.answer,
//           measureFn: (_ResponseData data, _) => data.percentage,
//           data: responseDataList,
//         );
//       },
//     ).toList();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Summary'),
//       ),
//       body: ListView.builder(
//         itemCount: surveyResponses?.length ?? 0,
//         itemBuilder: (context, index) {
//           final surveyResponse = surveyResponses?[index];
//           final chartSeries = _createChartSeries();
//           final series = chartSeries![index];
//
//           return Card(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Text(
//                     surveyResponse?.text ?? '',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     height: 200,
//                     child: charts.PieChart(
//                       [series],
//                       animate: true,
//                       defaultRenderer: charts.ArcRendererConfig(
//                         arcWidth: 60,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _ResponseData {
//   final String answer;
//   final double percentage;
//
//   _ResponseData(this.answer, this.percentage);
// }

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../service/survey_result_service.dart';
import '../utils/constants.dart';

class SurveySummaryScreen extends StatefulWidget {
  final String surveyId;

  SurveySummaryScreen({super.key, required this.surveyId});

  @override
  _SurveySummaryScreenState createState() => _SurveySummaryScreenState();
}

class _SurveySummaryScreenState extends State<SurveySummaryScreen> {
  List<SurveyQuestionResponse>? _surveyResponses;
  SurveyResult? _surveyDetails;
  final _surveyResultService = SurveyResultService();

  @override
  void initState() {
    super.initState();
    fetchSurveyResults();
  }

  Future<void> fetchSurveyResults() async {
    try {
      final surveyResult =
          await _surveyResultService.getDataFoCharts(widget.surveyId);
      final questionResponses = surveyResult['questionAnswerResponseDtoList'];
      final List<SurveyQuestionResponse> responses = questionResponses
          .map<SurveyQuestionResponse>(
              (response) => SurveyQuestionResponse.fromJson(response))
          .toList();

      setState(() {
        _surveyResponses = responses;
        _surveyDetails = SurveyResult.fromJson(surveyResult);
      });
    } catch (e) {
      print('Error fetching survey results: $e');
      // Handle error
    }
  }

  Map<String, double> createChartData(SurveyQuestionResponse response) {
    final responseDataList = response.responseAnswerMap.entries.toList();

    final Map<String, double> chartData = {};
    for (final entry in responseDataList) {
      final answer = entry.key;
      final count = entry.value;
      final percentage = count / _surveyResponses!.length * 100;
      chartData[answer] = percentage;
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.surveySummary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Survey Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Survey Name: ${_surveyDetails?.surveyName}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Total Responses: ${_surveyDetails?.totResponses}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _surveyResponses?.length ?? 0,
              itemBuilder: (context, index) {
                final surveyResponse = _surveyResponses![index];
                final chartData = createChartData(surveyResponse);

                return Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${index + 1}. ${surveyResponse.text}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            PieChart(
                              dataMap: chartData,
                              animationDuration:
                                  const Duration(milliseconds: 1000),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 32,
                              legendOptions: const LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SurveyResult {
  final String id;
  final String surveyName;
  final List<SurveyQuestionResponse> questionAnswerResponseDtoList;
  final int totResponses;

  SurveyResult({
    required this.id,
    required this.surveyName,
    required this.questionAnswerResponseDtoList,
    required this.totResponses,
  });

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    final List<dynamic> questionResponses =
        json['questionAnswerResponseDtoList'];
    final List<SurveyQuestionResponse> responses = questionResponses
        .map<SurveyQuestionResponse>(
            (response) => SurveyQuestionResponse.fromJson(response))
        .toList();

    return SurveyResult(
      id: json['id'],
      surveyName: json['surveyName'],
      questionAnswerResponseDtoList: responses,
      totResponses: json['totResponses'],
    );
  }
}

class SurveyQuestionResponse {
  final String id;
  final String text;
  final Map<String, int> responseAnswerMap;

  SurveyQuestionResponse({
    required this.id,
    required this.text,
    required this.responseAnswerMap,
  });

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionResponse(
      id: json['id'],
      text: json['text'],
      responseAnswerMap: Map<String, int>.from(json['responseAnswerMap']),
    );
  }
}
