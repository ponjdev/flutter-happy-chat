import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String message,
    {VoidCallback? onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              if (onConfirm != null) {
                onConfirm(); // Additional action on confirm
              }
            },
          ),
        ],
      );
    },
  );
}
