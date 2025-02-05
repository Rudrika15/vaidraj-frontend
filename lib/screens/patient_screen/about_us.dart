import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import "dart:math" as math;
import '../../constants/strings.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../home/home_screen.dart';

class AboutUsScreen extends StatelessWidget with NavigateHelper {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // will send user to my property page on back btn press
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        String role = await SharedPrefs.getRole();
        pushRemoveUntil(
            context,
            HomeScreen(
              isAdmin: role == "admin",
              isDoctor: role == "doctor",
              screenIndex: 6,
            ));
      },
      child: Consumer<LocalizationProvider>(
        builder: (context, langProvider, child) => SafeArea(
            child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
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
            SafeArea(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size20, vertical: AppSizes.size10),
              child: Column(
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.all(AppSizes.size10),
                    child: Text(
                      langProvider.translate('maharshi'),
                      textAlign: TextAlign.center,
                      style: TextSizeHelper.smallHeaderStyle,
                    ),
                  ),
                  MethodHelper.heightBox(height: 3.h),
                  Text(
                    langProvider.translate('aboutUsPara1'),
                    style: TextSizeHelper.smallTextStyle,
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  Text(
                    langProvider.translate('aboutUsPara2'),
                    style: TextSizeHelper.smallTextStyle,
                  ),
                  MethodHelper.heightBox(height: 3.h),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSizes.size20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint(
                            langProvider.translate("RHEUMATOIDARTHRITIS")),
                        _buildBulletPoint(langProvider.translate("ALLERGY")),
                        _buildBulletPoint(langProvider.translate("ASTHMA")),
                        _buildBulletPoint(
                            langProvider.translate("PEDIATRICASTHMA")),
                        _buildBulletPoint(langProvider.translate("MIGRAINE")),
                        _buildBulletPoint(langProvider
                            .translate("VERTEBRAE'SANDSPINALCORDDISEASES")),
                        _buildBulletPoint(
                            langProvider.translate("OSTEOARTHRITIS-KNEEJOINT")),
                        _buildBulletPoint(
                            langProvider.translate("GASTRODISEASES")),
                        _buildBulletPoint(
                            langProvider.translate("SKINDISEASES")),
                        _buildBulletPoint(
                            langProvider.translate("HAIR&BEAUTY")),
                        _buildBulletPoint(
                            langProvider.translate("DIABETESCONTROL")),
                        _buildBulletPoint(
                            langProvider.translate("HIGHBLOODPRESSURE")),
                      ],
                    ),
                  ),
                  MethodHelper.heightBox(height: 3.h),
                  Text(
                    langProvider.translate("aboutUsPara3"),
                    style: TextSizeHelper.smallTextStyle,
                  )
                ],
              ),
            ))
          ],
        )),
      ),
    );
  }
}

Widget _buildBulletPoint(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: AppSizes.size10),
        child: const Icon(Icons.circle, size: 8, color: Colors.black),
      ), // Bullet point icon
      const SizedBox(width: 8), // Space between the bullet and the text
      Expanded(
        child: Text(text, style: TextSizeHelper.smallTextStyle),
      ),
    ],
  );
}
