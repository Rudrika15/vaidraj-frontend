import 'package:flutter/material.dart';
import 'package:vaidraj/constants/color.dart';

import '../constants/text_size.dart';
import 'border_helper/border_helper.dart';

class MethodHelper {
  static SizedBox heightBox({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  static SizedBox widthBox({required double width}) {
    return SizedBox(
      width: width,
    );
  }

  static DecorationImage imageOrNoImage({required String image}) {
    return DecorationImage(
      image: NetworkImage(image),
      fit: BoxFit.cover,
      onError: (exception, stackTrace) =>
          AssetImage("assets/images/no-image-found.png"),
    );
  }

  static InputDecoration greenUnderLineBorder({
    required String hintText,
    Widget? suffix,
    // required IconData prefixIcon,
    // Color? prefixColor
  }) {
    return BorderHelper.greenInputBorder.copyWith(
      hintText: hintText,
      counterText: "",
      hintStyle: TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
      // prefix: Icon(
      //   prefixIcon,
      //   color: prefixColor ?? AppColors.greenColor,
      // ),
      suffix: suffix,
    );
  }

  static InputDecoration brownUnderLineBorder(
      {required String hintText,
      Widget? suffix,
      IconData? prefixIcon,
      Color? prefixColor}) {
    return BorderHelper.inputBorder.copyWith(
      hintText: hintText,
      counterText: "",
      hintStyle: TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
      prefix: Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(
          prefixIcon,
          color: prefixColor ?? AppColors.greenColor,
        ),
      ),
      suffix: suffix,
    );
  }
}
