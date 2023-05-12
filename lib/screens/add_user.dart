import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveyapp/helper/validator_helper.dart';

class AddUser extends StatefulWidget {
  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //final _userService = UserService();
  // final _user = User();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.nameValidate(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.emailValidate(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.passwordValidate(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return HelperValidator.validatePasswordMatch(
                      value, _passwordController.text.trim());
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Add User'),
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
    );
  }
}
