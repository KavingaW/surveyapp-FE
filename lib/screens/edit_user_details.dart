import 'package:flutter/material.dart';
import 'package:surveyapp/screens/user_dashboard.dart';
import 'package:surveyapp/screens/users_list_screen.dart';
import '../model/user_admin_response.dart';
import '../service/user_service.dart';
import '../utils/constants.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;

  EditUserScreen({required this.userId});

  @override
  EditUserScreenState createState() => EditUserScreenState();
}

class EditUserScreenState extends State<EditUserScreen> {
  final formKey = GlobalKey<FormState>();
  UserService userService = new UserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  late User _user = User.empty();

  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _loadUser() async {
    final user = await userService.getUserById(widget.userId);
    setState(() {
      _user = user;
      _usernameController.text = _user.username;
      _userEmailController.text = _user.email;
    });
  }

  _updateUser() async {
    if (formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.userId,
        username: _usernameController.text,
        email: _userEmailController.text,
      );

      return await userService.updateUser(widget.userId, updatedUser);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('User details updated.'),
      //     duration: Duration(seconds: 3),
      //     behavior: SnackBarBehavior.floating,
      //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      //   ),
      // );
      // Navigator.pop(context, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                //initialValue: _username,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onChanged: (value) {
                  // setState(() {
                  //   _username = value;
                  // });
                },
              ),
              TextFormField(
                controller: _userEmailController,
                //initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Password'),
              //   obscureText: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a password';
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     setState(() {
              //       _password = value;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Confirm Password'),
              //   obscureText: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please confirm your password';
              //     }
              //     if (value != _password) {
              //       return 'Passwords do not match';
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     setState(() {
              //       _confirmPassword = value;
              //     });
              //   },
              // ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        ConfirmationDialog(
                          onConfirm: () async {
                            //userService.deleteUser(TextFile.token, widget.user.id);
                            await _updateUser();
                            DeleteResponseMessage.show(
                              context,
                              'User has been updated successfully.',
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => UserDashboard(user:),
                            //   ),
                            // );
                          },
                          operation: AppConstants.operationUpdate,
                          message: AppConstants.messageUpdate,
                        ),
                  );

                  // List<User> userList = await userService.getUserList(TextFile.token);
                  //
                  // setState(() {
                  //   _userList = userList;
                  //});

                  // _updateUser();
                  // DeleteResponseMessage.show(context,'user  updated succesfully');
                  // Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => UsersScreen(),
                  //   ),
                  // );
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
