import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/screens/users_list_screen.dart';
import '../model/user_admin_response_model.dart';
import '../service/user_service.dart';
import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';

class UserUpdateScreen extends StatefulWidget {
  final User user;

  UserUpdateScreen({required this.user});

  @override
  UserUpdateScreenState createState() => UserUpdateScreenState();
}

class UserUpdateScreenState extends State<UserUpdateScreen> {
  final formKey = GlobalKey<FormState>();
  UserService userService = new UserService();
  final _usernameController = TextEditingController();
  final _userEmailController = TextEditingController();
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

  updateUser() async {
    if (formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.user.id,
        username: _usernameController.text,
        email: _userEmailController.text,
      );
      await userService.updateUser(widget.user.id, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.updateUser),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ConfirmationDialog(
                  onConfirm: () async {
                    await userService.deleteUser(widget.user.id);
                    ConfirmationResponseMessage.show(
                      context,
                      '${widget.user.username} has been deleted successfully.',
                    );
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersScreen(),
                      ),
                    );
                  },
                  operation: AppConstants.operationDelete,
                  message: AppConstants.messageDelete,
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
                decoration: InputDecoration(
                  labelText: AppConstants.labelTextUserName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.nameValidate(value!);
                },
                onChanged: (value) {},
              ),
              SizedBox(
                height: AppConstants.sizedBoxSizesHeight,
              ),
              TextFormField(
                controller: _userEmailController,
                decoration: InputDecoration(
                  labelText: AppConstants.labelEmail,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.emailValidate(value!);
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) => ConfirmationDialog(
                        onConfirm: () async {
                          //userService.deleteUser(TextFile.token, widget.user.id);
                          await updateUser();
                          ConfirmationResponseMessage.show(
                            context,
                            'User ${widget.user.username} has been updated successfully.',
                          );
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersScreen(),
                            ),
                          );
                        },
                        operation: AppConstants.operationUpdate,
                        message: AppConstants.messageUpdate,
                      ),
                    );
                  },
                  child: Text(AppConstants.updateUser),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
