import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Function onLogout;

  LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () {
        onLogout();
      },
    );
  }
}
