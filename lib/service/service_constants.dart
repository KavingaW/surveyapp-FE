import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceConstants {
  static String? BASE_URL = dotenv.env['BASE_URL'];

  static String AUTH_SERVICE_URL = '$BASE_URL/api/auth';
  static String QUESTION_SERVICE_URL = '$BASE_URL/api/question';
  static String SURVEY_RESULT_SERVICE_URL = '$BASE_URL/api/survey-result';
  static String SURVEY_SERVICE_URL = '$BASE_URL/api/survey';
  static String USER_SERVICE_URL = '$BASE_URL/api/user';
}
