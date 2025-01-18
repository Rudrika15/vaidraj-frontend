import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../../constants/color.dart';

class WidgetHelper {
  // show dialog
  static customSnackBar({
    required BuildContext context,
    required String title,
    Color? color,
    bool? isError,
  }) {
    if (isError ?? false) {
      // toastification;
      toastification.dismissAll();
      toastification.show(
        borderSide: BorderSide(color: color ?? Color(0xFF000000)),
        primaryColor: color,
        foregroundColor: AppColors.whiteColor,
        backgroundColor: AppColors.errorColor,
        // primaryColor: ColorHelper.kPrimary,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.error,
        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.fillColored, dragToClose: true,
        context: context, // optional if you use ToastificationWrapper
        title: Text(
          title,
          style: TextStyle(color: AppColors.whiteColor),
        ),
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.dismissAll();

      toastification.show(
        foregroundColor: AppColors.whiteColor,
        backgroundColor: color ?? AppColors.errorColor,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        context: context, // optional if you use ToastificationWrapper
        title: Text(title),
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }
}
