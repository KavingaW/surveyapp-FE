import 'package:flutter/material.dart';
import 'package:surveyapp/screens/user_update_screen.dart';

import '../model/user_token_response.dart';

class UserDashboard extends StatefulWidget {
  final User user;

  UserDashboard({required this.user});

  @override
  _UserDashboard createState() => _UserDashboard();

}

class _UserDashboard extends State<UserDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${widget.user.username}!'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UserUpdateScreen(user: widget.user),
                //   ),
                // );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
