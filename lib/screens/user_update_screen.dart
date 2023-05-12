import 'package:flutter/material.dart';
import 'package:surveyapp/screens/users_list_screen.dart';

import '../model/user_response.dart';
import '../service/user_service.dart';
import '../utils/constants.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';

class UserUpdateScreen extends StatefulWidget {
  final User user;

  UserUpdateScreen({required this.user});

  @override
  UserUpdateScreenState createState() => UserUpdateScreenState();
}

class UserUpdateScreenState extends State<UserUpdateScreen> {
  final formKey = GlobalKey<FormState>();
  UserService userService = new UserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _userEmailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    if (formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.user.id,
        username: _usernameController.text,
        email: _userEmailController.text,
      );

      userService.updateUser(
          TextFile.token, widget.user.id, updatedUser);

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
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) =>
                    DeleteConfirmationDialog(
                      onConfirm: () {
                        userService.deleteUser(TextFile.token, widget.user.id);
                        DeleteResponseMessage.show(
                          context,
                          'User ${widget.user
                              .username} has been deleted successfully.',
                        );
                       //Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersScreen(),
                          ),
                        );
                      },
                    ),
              );
            },
          ),
        ],
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
                        DeleteConfirmationDialog(
                          onConfirm: () {
                            //userService.deleteUser(TextFile.token, widget.user.id);
                            _updateUser();
                            DeleteResponseMessage.show(
                              context,
                              'User ${widget.user
                                  .username} has been updated successfully.',
                            );
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersScreen(),
                              ),
                            );
                          },
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
