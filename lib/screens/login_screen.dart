import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/screens/user_dashboard.dart';
import 'package:surveyapp/service/auth_service.dart';

import '../utils/constants.dart';
import '../widgets/login_error.dart';
import 'admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      try {
        final user = await authService.login(
            _usernameController.text, _passwordController.text);
        if (user.role == AppConstants.adminRole) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboard(),
            ),
          );
        } else if (user.role == AppConstants.userRole) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserDashboard(user: user),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Login Failed';
        });
        Timer(const Duration(seconds: 2), () {
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
        padding: EdgeInsets.all(AppConstants.edgeInsetsValue),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text('Survey APP',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          height: 5,
                          fontSize: 20))),
              const Center(
                  child: Icon(
                Icons.assessment,
                size: 100.0,
                color: Colors.cyan,
              )),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
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
              if (_errorMessage.isNotEmpty)
                LoginErrorWidget(errorMessage: _errorMessage),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text(AppConstants.logIn),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/resetPassword');
                    },
                    child: Text(AppConstants.forgotPassword),
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
