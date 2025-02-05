import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';

import '../../constants/sizes.dart';

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
  static InputDecoration dropDownOutlinedBorder(
          {required IconData suffixIcon}) =>
      InputDecoration(
        constraints: BoxConstraints(maxWidth: 50.w, maxHeight: 30.h),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size10, vertical: 0),
        suffixIcon: Icon(suffixIcon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.brownColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.brownColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.errorColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.brownColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.brownColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.size30),
            borderSide: const BorderSide(color: AppColors.errorColor)),
      );
}
