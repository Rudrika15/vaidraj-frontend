import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/color.dart';
import '../constants/text_size.dart';
import '../utils/border_helper/border_helper.dart';

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget(
      {super.key,
      required this.items,
      required this.onChanged,
      this.value,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.alignment = Alignment.center,
      this.decoration,
      this.dropdownColor});

  final List<DropdownMenuItem<Object?>>? items;
  final void Function(Object?)? onChanged;
  final Object? value;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(Object?)? validator;
  final AlignmentGeometry alignment;
  final InputDecoration? decoration;
  final Color? dropdownColor;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Object?>(
        menuMaxHeight: 25.h,
        value: value,
        items: items,
        isExpanded: true,
        iconSize: 0,
        alignment: alignment,
        onChanged: onChanged,
        validator: validator,
        dropdownColor: dropdownColor ?? AppColors.whiteColor,
        style: TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
        decoration: decoration ??
            BorderHelper.inputBorder.copyWith(
                hintText: hintText,
                hintStyle:
                    TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
                prefixIcon: Icon(
                  prefixIcon,
                  color: AppColors.greenColor,
                ),
                suffixIcon: Icon(
                  suffixIcon,
                  color: AppColors.greenColor,
                )));
  }
}
