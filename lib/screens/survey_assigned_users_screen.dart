import 'package:flutter/material.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/service/survey_service.dart';
import '../model/survey_api_model.dart';
import '../model/user_admin_response_model.dart';
import '../service/user_service.dart';
import '../utils/constants.dart';

class AssignedUsersScreen extends StatefulWidget {
  final Survey survey;

  AssignedUsersScreen({super.key, required this.survey});

  @override
  _AssignedUsersScreenState createState() => _AssignedUsersScreenState();
}

class _AssignedUsersScreenState extends State<AssignedUsersScreen> {
  final _userService = UserService();
  final _surveyService = SurveyService();
  List<User> _userList = [];
  List<User> _users = [];
  late User _selectedUser = User.empty();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    await _userService.getUserList().then((userList) {
      setState(() {
        _userList = userList;
        _users = _userList.map((user) => user).toSet().toList();
        if (_users.isNotEmpty) {
          _selectedUser = _users[0];
        } else {
          _selectedUser = User.empty();
        }
      });
    });
  }

  Future<void> addUserToList() async {
    if (_selectedUser != null &&
        !widget.survey.assigned.contains(_selectedUser)) {
      setState(() {
        widget.survey.assigned.add(_selectedUser);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppConstants.userSelected),
        ),
      );
    }
  }

  void deleteUser(int index) {
    setState(() {
      widget.survey.assigned.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.assignedUsers),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppConstants.addUsers,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxSizesHeight),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<User>(
                    decoration: InputDecoration(
                      labelText: AppConstants.selectUser,
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedUser,
                    items: _users.map((user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.username),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUser = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: addUserToList,
                  child: Text(AppConstants.add),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppConstants.currentUsers,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.survey.assigned.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: ListTile(
                      title: Text(widget.survey.assigned[index].username),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteUser(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _surveyService
                    .updateSurveyWithAssignedUsers(
                        widget.survey.id, widget.survey)
                    .then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SurveyListScreen()),
                  );
                });
              },
              child: Text(AppConstants.assignSurvey),
            ),
          )
        ],
      ),
    );
  }
}
