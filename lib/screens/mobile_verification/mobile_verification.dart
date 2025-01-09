import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/screens/signin_signup/sign_in_sign_up.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/green_divider.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import 'dart:math' as math;

import '../../constants/text_size.dart';
import '../../widgets/custom_text_field_widget.dart';

class MobileVerification extends StatelessWidget with NavigateHelper {
  MobileVerification({super.key});
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
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
                GreenDividerLine(endIndent: 50.w, indent: 16.w),
                MethodHelper.heightBox(height: 5.h),
                Form(
                    key: formkey,
                    child: CustomContainer(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: CustomTextFieldWidget(
                          hintText: "Mobile Number",
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          prefixIcon: Icons.phone_android_outlined,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Mobile Number Required";
                            }
                            return null;
                          },
                        ))),
              ],
            ),
          )
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size20, vertical: AppSizes.size10),
        child: CustomContainer(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: PrimaryBtn(
                btnText: "Submit",
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (mobileController.text == "8866752474") {
                      push(context, const SignInSignUp(UserStatus: "STAFF"));
                    } else if (mobileController.text == "1122334455") {
                      push(context, const SignInSignUp(UserStatus: "PATIENT"));
                    } else {
                      push(context, const SignInSignUp(UserStatus: "NEW"));
                    }
                    return;
                  }
                })),
      ),
    );
  }
}
