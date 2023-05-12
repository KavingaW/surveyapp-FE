import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //String _email, _password, _confirmPassword;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                   return HelperValidator.nameValidate(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    return HelperValidator.emailValidate(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'New Password'),
                  validator: (value) {
                    return HelperValidator.passwordValidate(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    return HelperValidator.validatePasswordMatch(
                        value, _passwordController.text);
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  child: const Text('Reset Password'),
                  onPressed: () {
                    _formKey.currentState?.validate();
                    // if (_formKey.currentState.validate()) {
                    //   //_formKey.currentState.save();
                    //   //_userService.addUser(_user);
                    //   Navigator.pop(context);
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String input) {
    // validate email pattern using a regular expression
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  void resetPassword() {
    final formState = _formKey.currentState;
    // if (formState.validate()) {
    //   formState.save();
    //   // call a reset password service with _email and _password fields
    // }
  }
}
