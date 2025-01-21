import 'package:flutter/material.dart';

import '../constants/color.dart';

class CustomIconBtnWidget extends StatelessWidget {
  const CustomIconBtnWidget(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.iconColor = AppColors.brownColor,
      this.iconSize = 20,
      this.iconBackGroundColor = AppColors.whiteColor,
      this.iconRadius = 0,
      this.splashColor = AppColors.lightBackGroundColor});
  //variables
  final void Function()? onPressed;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackGroundColor;
  final Color? splashColor;
  final double? iconSize;
  final double iconRadius;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        splashColor: splashColor,
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size.fromHeight(iconRadius)),
            backgroundColor: WidgetStatePropertyAll(iconBackGroundColor)),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ));
  }
}
