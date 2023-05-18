// import 'package:flutter/material.dart';
// import 'package:surveyapp/utils/constants.dart';
//
// import '../model/survey_api_response.dart';
// import '../model/user_admin_response.dart';
// import '../service/user_service.dart';
//
// class AssignedUsersScreen extends StatefulWidget {
//   final List<String> assignedUsers;
//
//   AssignedUsersScreen({required this.assignedUsers});
//
//   @override
//   _AssignedUsersScreenState createState() => _AssignedUsersScreenState();
// }
//
// class _AssignedUsersScreenState extends State<AssignedUsersScreen> {
//   final _userService = UserService();
//   late List<User> _userList;
//   List<String> _users = [];
//   String _selectedUser = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//     _userList = [];
//   }
//
//   void _loadUsers() {
//     _userService.getUserList(TextFile.token).then((userList) {
//       setState(() {
//         _userList = userList;
//       });
//     });
//     //List<String> userNames = users.map((user) => user.username).toList();
//     //_users = userNames;
//     // setState(() {
//     //   _users = userNames;
//     // });
//   }
//
//   void _addUser(String user) async {
//     final updatedSurvey = widget.survey.copyWith(
//       assigned: [...widget.survey.assigned, user],
//     );
//     //await SurveyService().updateSurvey(updatedSurvey);
//     setState(() {
//       widget.survey.assigned = updatedSurvey.assigned;
//     });
//   }
//
//   void _deleteUser(String user) {
//     setState(() {
//       widget.survey.assigned.remove(user);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Assigned Users'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Add Users',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       labelText: 'Select User',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: _selectedUser,
//                     items: _users.map((user) {
//                       return DropdownMenuItem<String>(
//                         value: user,
//                         child: Text(user),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedUser = newValue!;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: _addUserToList,
//                   child: Text('Add'),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Current Users',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                 itemCount: widget.survey.assigned.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                     child: ListTile(
//                       title: Text(widget.survey.assigned[index]),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           setState(() {
//                             widget.survey.assigned.removeAt(index);
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _deleteSurvey() {}
//
//   _addUserToList() {}
// }

import 'package:flutter/material.dart';
import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/service/survey_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/survey_api_response.dart';
import '../model/user_admin_response.dart';
import '../service/user_service.dart';

class AssignedUsersScreen extends StatefulWidget {
  final Survey survey;

  AssignedUsersScreen({required this.survey});

  @override
  _AssignedUsersScreenState createState() => _AssignedUsersScreenState();
}

class _AssignedUsersScreenState extends State<AssignedUsersScreen> {
  final _userService = UserService();
  final _surveyService = SurveyService();
  List<User> _userList = [];
  List<User> _users = [];
  //List<String> _userIds = [];
  String _selectedUser = '';
  String _userIdList = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _userService.getUserList().then((userList) {
      setState(() {
        _userList = userList;
        _users = _userList.map((user) => user).toSet().toList();
        //_userIds = _userList.map((user) => user.id).toSet().toList();
        if (_users.isNotEmpty) {
          _selectedUser = _users[0].username;
          //_userIdList = _userIds[0];
        } else {
          _selectedUser = "SELECT A USER";
        }
      });
    });
  }

  void _addUserToList() {
    if (_selectedUser.isNotEmpty) {
      setState(() {
        widget.survey.assigned.add(_selectedUser);
        //_selectedUser = '';
      });
      _surveyService.updateSurveyWithAssignedUsers(widget.survey.id, widget.survey);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => SurveyListScreen()),
      // );
    }
  }

  void _deleteUser(int index) {
    setState(() {
      widget.survey.assigned.removeAt(index);
    });
    _surveyService.updateSurveyWithAssignedUsers(widget.survey.id, widget.survey);
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
                        value: user.username,
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
                  onPressed: _addUserToList,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
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
                          _deleteUser(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
