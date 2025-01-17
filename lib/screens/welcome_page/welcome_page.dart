import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/mobile_verification/mobile_verification.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../widgets/green_divider.dart';

class WelcomePage extends StatelessWidget with NavigateHelper {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => Scaffold(
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
                Text(langProvider.translate("welcome"),
                    style: TextSizeHelper.xLargeHeaderStyle
                        .copyWith(color: AppColors.brownColor))
              ],
            ),
            GreenDividerLine(
              indent: 35.w,
              endIndent: 50.w,
            ),
            // height gap
            MethodHelper.heightBox(height: 5.h),

            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                langProvider.translate("welcomeLine"),
                textAlign: TextAlign.center,
                style: TextSizeHelper.smallTextStyle,
              ),
            ),
            // height gap
            MethodHelper.heightBox(height: 20.h),

            /// btn to get started
            PrimaryBtn(
              btnText: langProvider.translate("getStarted"),
              onTap: () {
                push(context, MobileVerification());
              },
            )
          ],
        )),
      )),
    );
  }
}
