import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';

class MedicalHistory extends StatelessWidget {
  const MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        children: [
          CustomContainer(
            borderColor: AppColors.brownColor,
            borderRadius: BorderRadius.circular(AppSizes.size10),
            borderWidth: 1,
            // width: 80.w,
            padding: const EdgeInsets.all(AppSizes.size10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Dr.ABC ',
                          style: TextSizeHelper.smallHeaderStyle,
                        )),
                    MethodHelper.widthBox(width: 2.w),
                    Text('2007-01-01')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
