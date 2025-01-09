import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import "dart:math" as math;

import '../../constants/strings.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  "Maharshi Chronic Disease Clinic & Research Center  (MCDCR VAIDRAJ)",
                  textAlign: TextAlign.center,
                  style: TextSizeHelper.smallHeaderStyle,
                ),
              ),
              MethodHelper.heightBox(height: 3.h),
              Text(
                "MCDCR VAIDRAJ was founded in 2006 it's aim is to research what are known as chronic and incurable diseases, to cure them from the root through side effect free Ayurvedic treatment. ",
                style: TextSizeHelper.smallTextStyle,
              ),
              MethodHelper.heightBox(height: 2.h),
              Text(
                "It is thier continuous effort to serve the patients suffering from incurable diseases and to cure them. After years of research, complete success has been achieved on the following diseases. And thousands of patients are completely cured of the following diseases.",
                style: TextSizeHelper.smallTextStyle,
              ),
              MethodHelper.heightBox(height: 3.h),
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint("RHEUMATOID ARTHRITIS"),
                    _buildBulletPoint("ALLERGY"),
                    _buildBulletPoint("ASTHMA"),
                    _buildBulletPoint("PEDIATRIC ASTHMA"),
                    _buildBulletPoint("MIGRAINE"),
                    _buildBulletPoint("VERTEBRAE'S AND SPINAL CORD DISEASES"),
                    _buildBulletPoint("OSTEOARTHRITIS-KNEE JOINT"),
                    _buildBulletPoint("GASTRO DISEASES"),
                    _buildBulletPoint("SKIN DISEASES"),
                    _buildBulletPoint("HAIR & BEAUTY"),
                    _buildBulletPoint("DIABETES CONTROL"),
                    _buildBulletPoint("HIGH BLOOD PRESSURE"),
                  ],
                ),
              ),
              MethodHelper.heightBox(height: 3.h),
              Text(
                "The fundamental goal of MCDCR VAIDRAJ is to treat what are classified as incurable diseases, which are still deemed incurable today. Investigating diseases that, despite various treatments, cannot be cured  and to heal such diseases with side effect-free Ayurvedic treatment, as well as to aid individuals suffering from incurable diseases and to entirely heal them. MCDCR Ayurveda began with this goal in mind and will celebrate its 16th anniversary in 2022. We have been able to heal numerous incurable diseases, as well as thousands of patients suffering from chronic disease.",
                style: TextSizeHelper.smallTextStyle,
              )
            ],
          ),
        ))
      ],
    ));
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
