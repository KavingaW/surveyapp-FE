import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/service/auth_service.dart';

import '../widgets/login_error.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage='';
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      try {
        final user = await authService.login(
            _usernameController.text, _passwordController.text);
        if (user.role == 'ROLE_ADMIN') {
          Navigator.of(context).pushNamed('/adminDashboard');
        }else if(user.role == "ROLE_USER"){
          Navigator.of(context).pushNamed('/userDashboard');
        }
        // TODO: Navigate to the home screen
      } catch (e) {
        setState(() {
          _errorMessage = 'Login Failed';
        });
        Timer(Duration(seconds: 2), () {
          setState(() {
            _usernameController.clear();
            _passwordController.clear();
            _errorMessage = '';
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text('Survey APP',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          height: 5,
                          fontSize: 20))),
              Center(
                  child: Icon(
                Icons.assessment,
                size: 100.0,
                color: Colors.cyan,
              )),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.nameValidate(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.passwordValidate(value!);
                },
              ),
              SizedBox(height: 16.0),
              if (_errorMessage.isNotEmpty)
                LoginErrorWidget(errorMessage: _errorMessage),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // if(_formKey.currentState!.validate()){
                      //   var role = authService.login(
                      //     _usernameController.text, _passwordController.text);
                      //   print('ko'+role.toString());
                      // if(role.toString() ==  'ROLE_ADMIN'){
                      //   Navigator.of(context).pushNamed('/adminDashboard');
                      // }
                      // }
                      _login();
                    },
                    child: Text('Log in'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/resetPassword');
                    },
                    child: Text('Forgot password?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
