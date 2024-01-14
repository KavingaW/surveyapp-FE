import 'package:flutter/material.dart';
import 'package:surveyapp/screens/admin_user_update_screen.dart';

import 'package:surveyapp/service/user_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/user_admin_response_model.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';
import 'add_user_screen.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<StatefulWidget> {
  late List<User> _userList=[];
  late List<User> _filteredUserList = [];
  final userService = UserService();

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


  void filterUsers(String query) {
    setState(() {
      _filteredUserList = _userList.where((user) {
        final username = user.username.toLowerCase();
        final email = user.email.toLowerCase();
        final lowerCaseQuery = query.toLowerCase();
        return username.contains(lowerCaseQuery) || email.contains(lowerCaseQuery);
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered User List',style: TextStyle(fontFamily: 'RobotoMono'),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? selected = await showSearch<String>(
                context: context,
                delegate: UserSearchDelegate(_userList),
              );
              if (selected != null && selected.isNotEmpty) {
                filterUsers(selected);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (BuildContext context, int index) {
          User user = _userList[index];
          return Card(
             child: ListTile(
                leading: const Icon(Icons.supervised_user_circle_rounded,size: 50.0,color: Colors.cyan,),
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
              ),
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

class UserSearchDelegate extends SearchDelegate<String> {
  final List<User> userList;

  UserSearchDelegate(this.userList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Implement your own search results view
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<User> filteredList = userList.where((user) {
      final username = user.username.toLowerCase();
      final email = user.email.toLowerCase();
      final query = this.query.toLowerCase();
      return username.contains(query) || email.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        final User user = filteredList[index];
        return ListTile(
          leading: const Icon(Icons.supervised_user_circle_rounded, size: 50.0,color: Colors.cyan),
          title: Text(user.username,style: TextStyle(color: Colors.black),),
          subtitle: Text(user.email, style: TextStyle(color: Colors.black),),
          onTap: () {
            close(context, user.username);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserUpdateScreen(user: user),
              ),
            );
          },
        );
      },
    );
  }
}