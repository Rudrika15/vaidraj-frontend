import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/mobile_verification_provider.dart';
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
    return Consumer2<LocalizationProvider, MobileVerificationProvider>(
      builder: (context, langProvider, mobileVerProvider, child) => Scaffold(
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
                      Text(langProvider.translate("mobileVerification"),
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
                            decoration: MethodHelper.brownUnderLineBorder(
                                hintText:
                                    langProvider.translate("mobileNumber"),
                                prefixIcon: Icons.phone_android_outlined),
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return langProvider
                                    .translate("mobileNumberReq");
                              }
                              if (value?.contains(RegExp(r"[ ,-.]")) ?? true) {
                                return langProvider.translate("mobileNotValid");
                              }
                              if (value?.contains(
                                      RegExp(r'^\D*(\d\D*){0,9}$')) ??
                                  true) {
                                return langProvider.translate("mobileNotValid");
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
                  btnText: langProvider.translate("submit"),
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      await mobileVerProvider.verifyMobile(
                          context: context,
                          mobileNumber: mobileController.text);
                      if (mobileVerProvider.verifyMobileNumberModel?.success ==
                          true) {
                        //here this will change the language of app to previous or to defualt english
                        langProvider.setCurrentLocal(
                            langToSet: mobileVerProvider
                                    .verifyMobileNumberModel?.data?.language ??
                                "en");
                        await langProvider.load(mobileVerProvider
                                .verifyMobileNumberModel?.data?.language ??
                            "en");
                        if (mobileVerProvider
                                .verifyMobileNumberModel?.data?.role ==
                            "admin") {
                          push(
                              context, const SignInSignUp(UserStatus: "ADMIN"));
                          return;
                        }
                        if (mobileVerProvider
                                .verifyMobileNumberModel?.data?.role ==
                            "doctor") {
                          push(
                              context, const SignInSignUp(UserStatus: "STAFF"));
                          return;
                        }
                        if (mobileVerProvider
                                .verifyMobileNumberModel?.data?.role ==
                            "patient") {
                          push(context,
                              const SignInSignUp(UserStatus: "PATIENT"));
                          return;
                        }
                      } else {
                        /// passing mobile number to registration screen
                        push(
                            context,
                            SignInSignUp(
                              UserStatus: "NEW",
                              phoneNumber: mobileController.text,
                            ));
                        return;
                      }
                      return;
                    }
                  })),
        ),
      ),
    );
  }
}
