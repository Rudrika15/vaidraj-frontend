import 'package:flutter/material.dart';
import 'package:vaidraj/constants/color.dart';

class BorderHelper {
  static InputDecoration inputBorder = const InputDecoration(
    border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.brownColor)),
    disabledBorder: UnderlineInputBorder(
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

  static InputDecoration greenInputBorder = const InputDecoration(
    border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.greenColor)),
    disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.greenColor)),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor)),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.greenColor)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.greenColor)),
    focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor)),
  );
  static InputDecoration brownAllBorder = const InputDecoration(
    border:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.brownColor)),
    disabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.brownColor)),
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.errorColor)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.brownColor)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.brownColor)),
    focusedErrorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.errorColor)),
  );
}
