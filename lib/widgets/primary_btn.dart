import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import '../constants/text_size.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn(
      {super.key,
      this.height,
      this.width,
      this.backGroundColor,
      this.borderRadius,
      required this.btnText,
      this.textStyle,
      required this.onTap});
  final double? width;
  final double? height;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final String btnText;
  final TextStyle? textStyle;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 80.w,
      height: height ?? 6.h,
      child: MaterialButton(
        onPressed: onTap,
        elevation: 0,
        color: backGroundColor ?? AppColors.brownColor,
        shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppSizes.size20)),
        child: Text(
          btnText,
          style: textStyle ??
              TextSizeHelper.mediumHeaderStyle
                  .copyWith(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
