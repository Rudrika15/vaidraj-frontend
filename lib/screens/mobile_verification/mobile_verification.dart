import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'dart:math' as math;

import '../../constants/text_size.dart';
import '../../widgets/custom_text_field_widget.dart';

class MobileVerification extends StatelessWidget {
  const MobileVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            top: 30.h,
            right: -5.w,
            child: Opacity(
              opacity: 0.2,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Image(
                  image: AssetImage(AppStrings.logoHerb),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60.h,
            left: -5.w,
            child: const Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage(AppStrings.logoHerb),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          CustomContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomContainer(
                  width: 100.w,
                  height: 20.h,
                  image: const DecorationImage(
                      image: AssetImage(AppStrings.image3),
                      fit: BoxFit.contain),
                ),
                MethodHelper.heightBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Mobile Verification",
                        style: TextSizeHelper.xLargeHeaderStyle
                            .copyWith(color: AppColors.brownColor))
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: AppColors.greenColor,
                  indent: 16.w,
                  endIndent: 50.w,
                ),
                MethodHelper.heightBox(height: 5.h),
                Form(
                    child: CustomContainer(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                hintText: "Mobile Number",
                                prefixIcon: Icons.phone_android_outlined,
                              ),
                            )
                          ],
                        )))
              ],
            ),
          )
        ],
      )),
    );
  }
}
