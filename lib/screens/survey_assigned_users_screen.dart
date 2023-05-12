import 'package:flutter/material.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/survey_api_response.dart';
import '../service/user_service.dart';

class AssignedUsersScreen extends StatefulWidget {
  final Survey survey;

  AssignedUsersScreen({required this.survey});

  @override
  _AssignedUsersScreenState createState() => _AssignedUsersScreenState();
}

class _AssignedUsersScreenState extends State<AssignedUsersScreen> {
  final _userService = UserService();
  List<String> _users = [];
  String _selectedUser = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {

    setState(() {
      _users = _userService.getUserList(TextFile.token) as List<String>;
    });
  }

  void _addUser(String user) async {
    final updatedSurvey = widget.survey.copyWith(
      assigned: [...widget.survey.assigned, user],
    );
    //await SurveyService().updateSurvey(updatedSurvey);
    setState(() {
      widget.survey.assigned = updatedSurvey.assigned;
    });
  }

  void _deleteUser(String user) {
    setState(() {
      widget.survey.assigned.remove(user);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Users'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.survey.assigned.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: ListTile(
                      title: Text(widget.survey.assigned[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.survey.assigned.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select User',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedUser,
                    items: _users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user,
                        child: Text(user),
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
                  onPressed: _addUserToList,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  _deleteSurvey() {}
  _addUserToList(){}
}