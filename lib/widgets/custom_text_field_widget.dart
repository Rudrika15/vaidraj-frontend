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
      this.suffixColor,
      required this.validator,
      this.maxLength,
      required this.keyboardType,
      required this.controller,
      this.minLines,
      this.maxLines,
      this.obscureText = false,
      this.enabled = true,
      this.suffix,
      this.isGreenBorder = true});
  final String hintText;
  final IconData? prefixIcon;
  final Color? prefixColor;
  final Color? suffixColor;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  final bool isGreenBorder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      style: TextSizeHelper.smallHeaderStyle,
      minLines: minLines,
      maxLines: maxLines,
      decoration: isGreenBorder
          ? BorderHelper.greenInputBorder.copyWith(
              hintText: hintText,
              counterText: "",
              hintStyle: TextSizeHelper.smallTextStyle,
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: prefixColor ?? AppColors.greenColor,
                    )
                  : null,
              suffixIcon: suffix == null
                  ? Icon(
                      suffixIcon,
                      color: suffixColor ?? AppColors.greenColor,
                    )
                  : null,
              suffix: suffix,
            )
          : BorderHelper.inputBorder.copyWith(
              hintText: hintText,
              counterText: "",
              hintStyle: TextSizeHelper.smallTextStyle,
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: prefixColor ?? AppColors.greenColor,
                    )
                  : null,
              suffixIcon: suffix == null
                  ? Icon(
                      suffixIcon,
                      color: suffixColor ?? AppColors.greenColor,
                    )
                  : null,
              suffix: suffix,
            ),
    );
  }
}
