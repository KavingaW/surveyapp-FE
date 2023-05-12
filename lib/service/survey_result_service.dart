// import '../model/result_list_api_response.dart';
// import 'package:http/http.dart' as http;
//
// class SurveyResultService {
//   static const String baseUrl = 'http://10.0.2.2:8080/api/survey-result';
//   late String userId;
//   Future<List<SurveyListResult>> getSurveyList() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/$userId'),
//       // headers: <String, String>{
//       //   'Authorization': 'Bearer $token',
//       // },
//     );
//
//   //   if (response.statusCode == 200) {
//   //     var jsonData = jsonDecode(response.body) as List;
//   //     List<Survey> surveyList =
//   //     jsonData.map((e) => Survey.fromJson(e)).toList();
//   //     return surveyList;
//   //   } else {
//   //     throw Exception("Error on fetching data");
//   //   }
//   // }
// }