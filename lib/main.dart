import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:surveyapp/routes/app_routes.dart';
import 'package:surveyapp/screens/add_user.dart';
import 'package:surveyapp/screens/admin_dashboard.dart';
import 'package:surveyapp/screens/login_screen.dart';
import 'package:surveyapp/screens/reset_password.dart';
import 'package:surveyapp/screens/results_list_screen.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/screens/users_list_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      //home: AddUser(),
     // home: AdminDashboard(),
      home: LoginScreen(),
      routes: appRoutes,
      //  <String, WidgetBuilder>{
      //   '/resetPassword': (context) => ResetPasswordScreen(),
      //    '/userslist': (context) => UsersScreen(),
      //    '/surveyslist': (context) => SurveysScreen(),
      //    '/resultslist': (context) => ReslutsListScreen(),
      //    '/adminDashboard': (context) => AdminDashboard(),
      //    '/loginScreen': (context) => LoginScreen(),
      // },
    );
  }
}
