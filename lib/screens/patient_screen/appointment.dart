import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/screens/patient_screen/get_in_touch.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

import '../../constants/color.dart';
import '../../constants/text_size.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key, this.fromPage = false});
  final bool fromPage;
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: widget.fromPage
          ? AppBar(
              backgroundColor: AppColors.whiteColor,
              title: Text(
                "Book Appointment",
                style: TextSizeHelper.mediumTextStyle
                    .copyWith(color: AppColors.brownColor),
              ),
            )
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(0), // This effectively removes the AppBar
              child: Container(), // Empty container when no AppBar is needed
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoWithInfoContainer(children: [
              Text(
                "Maharshi Chronic Disease Clinic & Research Center  (MCDCR VAIDRAJ)",
                style: TextSizeHelper.xSmallTextStyle,
              ),
              MethodHelper.heightBox(height: 3.h),
              Row(
                children: [
                  PrimaryBtn(
                    btnText: "Send Email",
                    onTap: () {
                      // add logic to email
                    },
                    height: 3.h,
                    width: 25.w,
                    borderRadius: BorderRadius.circular(5),
                    backGroundColor: AppColors.whiteColor,
                    borderColor: AppColors.brownColor,
                    textStyle: TextSizeHelper.xSmallTextStyle
                        .copyWith(color: AppColors.brownColor),
                  ),
                  MethodHelper.widthBox(width: 2.w),
                  PrimaryBtn(
                    btnText: "Call",
                    onTap: () {
                      // add logic to call
                    },
                    height: 3.h,
                    width: 25.w,
                    borderRadius: BorderRadius.circular(5),
                    borderColor: AppColors.brownColor,
                    textStyle: TextSizeHelper.xSmallTextStyle
                        .copyWith(color: AppColors.whiteColor),
                  )
                ],
              )
            ]),
            ToggleBtn(isSelected: false, text: "Btn")
          ],
        ),
      ),
    );
  }
}

class ToggleBtn extends StatefulWidget {
  const ToggleBtn(
      {super.key,
      required this.isSelected,
      this.height,
      this.width,
      required this.text});
  final bool isSelected;
  final double? height;
  final double? width;
  final String text;
  @override
  State<ToggleBtn> createState() => _ToggleBtnState();
}

class _ToggleBtnState extends State<ToggleBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CustomContainer(
        backGroundColor: widget.isSelected
            ? AppColors.backgroundColor
            : AppColors.whiteColor,
        borderColor: AppColors.brownColor,
        borderRadius: BorderRadius.circular(5),
        height: widget.height ?? 4.h,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Text(
          widget.text,
          style: TextSizeHelper.xSmallTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
