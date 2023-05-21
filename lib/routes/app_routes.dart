import 'package:flutter/material.dart';
import 'package:surveyapp/screens/user_dashboard.dart';

import '../screens/admin_dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/reset_password.dart';
import '../screens/results_list_screen.dart';
import '../screens/surveys_list_screen.dart';
import '../screens/users_list_screen.dart';


Map<String, WidgetBuilder> appRoutes = {
  '/resetPassword': (context) => ResetPasswordScreen(),
  '/userslist': (context) => UsersScreen(),
   '/surveyslist': (context) => SurveyListScreen(),
   '/resultslist': (context) => ResultsListScreen(),
  '/adminDashboard': (context) => AdminDashboard(),
  '/loginScreen': (context) => LoginScreen(),
  //'/userDashboard': (context) => UserDashboard(),
};