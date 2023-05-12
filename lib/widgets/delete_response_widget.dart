import 'package:flutter/material.dart';

class DeleteResponseMessage extends StatelessWidget {
  final String message;

  DeleteResponseMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[800],
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 20,),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: DeleteResponseMessage(message: message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      )
    );
  }
}
