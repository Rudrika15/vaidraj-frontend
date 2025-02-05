import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {
  final String content;
  final String heading;
  final String secondBtnText;
  final VoidCallback onPressedSecondBtn;

  const CustomAlertBox({
    Key? key,
    required this.content,
    required this.heading,
    required this.secondBtnText,
    required this.onPressedSecondBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        heading,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: onPressedSecondBtn, // Trigger the exit action
          child: Text(secondBtnText),
        ),
      ],
    );
  }
}
