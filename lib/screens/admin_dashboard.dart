import 'package:flutter/material.dart';
import 'package:surveyapp/screens/login_screen.dart';
import 'package:surveyapp/service/auth_service.dart';

import '../utils/constants.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';
import '../widgets/logout_widget.dart';

// import 'package:my_app/screens/user_screen.dart';
// import 'package:my_app/screens/survey_screen.dart';
// import 'package:my_app/screens/result_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          LogoutButton(onLogout: () {
            showDialog(
              context: context,
              builder: (_) => ConfirmationDialog(
                onConfirm: () async {
                  //userService.deleteUser(TextFile.token, widget.user.id);
                  DeleteResponseMessage.show(
                    context,
                    'Successfully logged out.',
                  );

                  Navigator.pop(context);
                  AuthService authService = AuthService();
                  authService.logOut();
                  Navigator.pushReplacementNamed(context, '/loginScreen');
                },
                operation: AppConstants.operationLogout,
                message: AppConstants.messageLogout,
              ),
            );
          }),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/userslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person, size: 80.0),
                    SizedBox(height: 16.0),
                    Text('Users'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/surveyslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.assignment, size: 80.0),
                    SizedBox(height: 16.0),
                    Text('Surveys'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/resultslist');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.poll, size: 80.0),
                    SizedBox(height: 16.0),
                    Text('Results'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
