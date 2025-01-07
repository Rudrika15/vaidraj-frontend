import 'package:flutter/material.dart';
import 'package:vaidraj/constants/color.dart';

class BorderHelper {
  static InputDecoration inputBorder = const InputDecoration(
    border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brownColor)),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor)),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brownColor)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brownColor)),
    focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor)),
  );
}