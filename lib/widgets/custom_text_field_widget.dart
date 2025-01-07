import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/text_size.dart';
import '../utils/border_helper/border_helper.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget(
      {super.key,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixColor,
      this.suffixColor});
  final String hintText;
  final IconData? prefixIcon;
  final Color? prefixColor;
  final Color? suffixColor;
  final IconData? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: BorderHelper.inputBorder.copyWith(
        hintText: hintText,
        hintStyle: TextSizeHelper.smallTextStyle,
        prefixIcon: Icon(
          prefixIcon,
          color: prefixColor ?? AppColors.greenColor,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: suffixColor ?? AppColors.greenColor,
        ),
      ),
    );
  }
}