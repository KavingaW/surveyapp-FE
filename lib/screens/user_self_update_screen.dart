import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import '../model/user_admin_response_model.dart';
import '../service/user_service.dart';
import '../utils/constants.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;

  EditUserScreen({super.key, required this.userId});

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
    loadUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void loadUser() async {
    final user = await userService.getUserById(widget.userId);
    setState(() {
      _user = user;
      _usernameController.text = _user.username;
      _userEmailController.text = _user.email;
    });
  }

  updateUser() async {
    if (formKey.currentState!.validate()) {
      User updatedUser = User(
        id: widget.userId,
        username: _usernameController.text,
        email: _userEmailController.text,
      );
      return await userService.updateUser(widget.userId, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User '),
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
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  return HelperValidator.nameValidate(value!);
                },
                onChanged: (value) {
                },
              ),
              TextFormField(
                controller: _userEmailController,
                //initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  return HelperValidator.emailValidate(value!);
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
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
                            'User has been updated successfully.',
                          );

                          Navigator.pop(context);
                          Navigator.pop(context);

                        },
                        operation: AppConstants.operationUpdate,
                        message: AppConstants.messageUpdate,
                      ),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/resetPassword');
                  },
                  child: Text(AppConstants.resetPasswordTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
