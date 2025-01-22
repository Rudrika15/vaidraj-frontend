import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/widgets/green_divider.dart';
import '../constants/color.dart';
import '../constants/text_size.dart';
import 'custom_container.dart';

class InScreenHeading extends StatelessWidget {
  const InScreenHeading(
      {super.key, required this.heading, this.endIndent, this.indent});
  final String heading;
  final double? endIndent;
  final double? indent;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextSizeHelper.mediumHeaderStyle
                .copyWith(color: AppColors.brownColor),
          ),
          GreenDividerLine(endIndent: endIndent ?? 70.w, indent: indent ?? 1.w)
        ],
      ),
    );
  }
}
