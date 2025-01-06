import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// image on top
            CustomContainer(
              height: 35.h,
              width: 100.w,
              image: const DecorationImage(
                  image: AssetImage(AppStrings.image1), fit: BoxFit.cover),
            ),
            MethodHelper.heightBox(height: 5.h),

            /// welcome heading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Welcome",
                    style: TextSizeHelper.xLargeHeaderStyle
                        .copyWith(color: AppColors.brownColor))
              ],
            ),
            Divider(
              thickness: 2,
              color: AppColors.greenColor,
              indent: 35.w,
              endIndent: 50.w,
            ),
            // height gap
            MethodHelper.heightBox(height: 5.h),

            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                AppStrings.welcomeText,
                textAlign: TextAlign.center,
                style: TextSizeHelper.smallTextStyle,
              ),
            ),
            // height gap
            MethodHelper.heightBox(height: 20.h),

            /// btn to get started
            PrimaryBtn(
              btnText: "Get Statrted",
              onTap: (){},
            )
          ],
        )),
      ),
    );
  }
}
