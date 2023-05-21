import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/model/user_admin_response_model.dart';
import 'package:surveyapp/utils/constants.dart';

import '../model/user_request_model.dart';
import '../service/user_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userService = UserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.resetPasswordTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.edgeInsetsValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: AppConstants.sizedBoxSizesHeight),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: AppConstants.labelTextUserName),
                  validator: (value) {
                    return HelperValidator.nameValidate(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      InputDecoration(labelText: AppConstants.labelEmail),
                  validator: (value) {
                    return HelperValidator.emailValidate(value!);
                  },
                ),
                SizedBox(height: AppConstants.sizedBoxSizesHeight),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: AppConstants.newPasswordLabel),
                  validator: (value) {
                    return HelperValidator.passwordValidate(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: AppConstants.labelConfirmPassword),
                  validator: (value) {
                    return HelperValidator.validatePasswordMatch(
                        value, _passwordController.text);
                  },
                ),
                SizedBox(height: AppConstants.sizedBoxSizesHeight),
                ElevatedButton(
                  child: Text(AppConstants.resetPasswordTitle),
                  onPressed: () {
                    _formKey.currentState?.validate();
                    if (_formKey.currentState!.validate()) {
                      Set<String> role = {};
                      UserRequest user = UserRequest(
                          username: _usernameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          role: role);
                      _userService.resetUserPassword(user);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
