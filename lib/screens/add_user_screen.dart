import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/model/user_request_model.dart';
import 'package:surveyapp/screens/users_list_screen.dart';
import 'package:surveyapp/utils/constants.dart';
import '../service/user_service.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userService = UserService();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.userAddTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.edgeInsetsValue),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: AppConstants.labelTextUserName,
                  hintText: AppConstants.userNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.nameValidate(value!);
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppConstants.labelEmail,
                  hintText: AppConstants.emailHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.emailValidate(value!);
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppConstants.labelPassword,
                  hintText: AppConstants.passwordHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.passwordValidate(value!);
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppConstants.labelConfirmPassword,
                  hintText: AppConstants.passwordHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.validatePasswordMatch(
                      value, _passwordController.text.trim());
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              ElevatedButton(
                child: Text(AppConstants.buttonAddUser),
                onPressed: () async {
                  _formKey.currentState?.validate();
                  if (_formKey.currentState!.validate()) {
                    Set<String> role = {'user'};
                    var user = UserRequest(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        role: role);
                    await _userService.addUser(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
