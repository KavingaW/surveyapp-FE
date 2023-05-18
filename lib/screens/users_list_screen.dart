import 'package:flutter/material.dart';
import 'package:surveyapp/screens/user_update_screen.dart';

import 'package:surveyapp/service/user_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/user_admin_response.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';
import 'add_user.dart';

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

  loadUsers() async {
    await userService
        .getUserList()
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
        title: Text('Registered User List',style: TextStyle(fontFamily: 'RobotoMono'),),
      ),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (BuildContext context, int index) {
          User user = _userList[index];
          return ListTile(
            leading: Icon(Icons.supervised_user_circle_rounded,size: 50.0,),
            title: Text(user.username),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserUpdateScreen(user: user),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddUser()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
