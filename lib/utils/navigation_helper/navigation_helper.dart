import 'package:flutter/material.dart';

mixin NavigateHelper {
  // for push navigation
  push(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  // for push remove navigation
  pushRemoveUntil(BuildContext context, Widget widget, {bool? isRoute}) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
        (route) => isRoute ?? false);
  }

  // for pop navigation
  pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  // for push remove navigation
  pushReplace(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}
