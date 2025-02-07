import 'package:flutter/material.dart';
import 'package:vaidraj/constants/text_size.dart';

class CustomAlertBox extends StatelessWidget {
  final String content;
  final String heading;
  final String? firstBtnText;
  final String secondBtnText;
  final VoidCallback onPressedSecondBtn;
  final Color? color;

  const CustomAlertBox(
      {Key? key,
      required this.content,
      required this.heading,
      this.firstBtnText,
      required this.secondBtnText,
      required this.onPressedSecondBtn,
      this.color})
      : super(key: key);

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
          child: Text(
            firstBtnText ?? 'Cancel',
            style: TextSizeHelper.smallTextStyle,
          ),
        ),
        TextButton(
          onPressed: onPressedSecondBtn, // Trigger the exit action
          child: Text(
            secondBtnText,
            style: TextSizeHelper.smallTextStyle.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
