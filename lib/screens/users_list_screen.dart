import 'package:flutter/material.dart';
import 'package:surveyapp/screens/user_update_screen.dart';

import 'package:surveyapp/service/user_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/user_response.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<StatefulWidget> {
  late List<User> _userList=[];
  UserService userService = new UserService();

  @override
  void initState() {
    super.initState();
    //_userList = [];
    loadUsers();
  }

  void loadUsers() async {
    userService
        .getUserList(TextFile.token)
        .then((userList) {
      setState(() {
        _userList = userList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered User List'),
      ),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (BuildContext context, int index) {
          User user = _userList[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserUpdateScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
