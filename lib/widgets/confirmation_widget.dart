import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  String operation;
  String message;

  ConfirmationDialog(
      {required this.onConfirm, required this.operation, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm $operation'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(operation),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}
