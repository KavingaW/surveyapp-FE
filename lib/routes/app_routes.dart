import 'package:flutter/material.dart';

import '../screens/admin_dashboard.dart';
import '../screens/login_screen.dart';
import '../screens/reset_password.dart';
import '../screens/results_list_screen.dart';
import '../screens/surveys_list_screen.dart';
import '../screens/users_list_screen.dart';


Map<String, WidgetBuilder> appRoutes = {
  '/resetPassword': (context) => ResetPasswordScreen(),
  //'/userDashboard': (context) =>
  '/userslist': (context) => UsersScreen(),
  '/surveyslist': (context) => SurveyListScreen(),
  '/resultslist': (context) => ResultsListScreen(),
  '/adminDashboard': (context) => AdminDashboard(),
  '/loginScreen': (context) => LoginScreen(),
};