import 'package:flutter/material.dart';
import '../constants/text_size.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget(
      {super.key,
      required this.validator,
      this.maxLength,
      required this.keyboardType,
      required this.controller,
      this.minLines,
      this.maxLines,
      this.obscureText = false,
      this.enabled = true,
      this.suffix,
      required this.decoration});
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        style: TextSizeHelper.smallHeaderStyle.copyWith(color: Colors.black),
        minLines: minLines,
        maxLines: maxLines,
        decoration: decoration);
  }
}
