import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import "dart:math" as math;

import '../../constants/strings.dart';

class GetInTouchScreen extends StatelessWidget {
  const GetInTouchScreen({super.key});

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
          child: Column(
            children: [
              CustomContainer(
                height: 20.h,
                backGroundColor: AppColors.backgroundColor,
                child: Row(
                  children: [Expanded(child: VaidrajLogo())],
                ),
              )
            ],
          ),
        ))
      ],
    ));
  }
}
