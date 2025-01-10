import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

import '../../constants/color.dart';
import '../../constants/text_size.dart';
import '../../widgets/in_app_heading.dart';

class ViewProductOrAppointment extends StatelessWidget {
  const ViewProductOrAppointment({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        title: Text(
          title,
          style: TextSizeHelper.mediumTextStyle
              .copyWith(color: AppColors.brownColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size20, vertical: AppSizes.size10),
        child: Column(
          children: [
            CustomContainer(
              borderRadius: BorderRadius.circular(AppSizes.size10),
              borderColor: AppColors.brownColor,
              height: 20.h,
              image:
                  DecorationImage(image: AssetImage("assets/images/pain.jpg")),
            ),
            MethodHelper.heightBox(height: 3.h),
            Text(
              "Due to today's sedentary lifestyle and improper diet, the number of people suffering from Arthritis is constantly increasing in every country of the world.",
              style: TextSizeHelper.smallTextStyle,
              textAlign: TextAlign.justify,
            ),
            MethodHelper.heightBox(height: 2.h),
            Text(
              "Arthritis can occur at any age in any joint of the body (hands, feet, ankles, spine, waist, ankles, knees, feet, shoulders, elbows, etc.). which is an auto immune disorder. At present, modern science does not have any effective treatment for joint pain, which can be cured from the root by regular intake. But until treatment is taken, there is relief. And the side effects of those drugs are also many.",
              style: TextSizeHelper.smallTextStyle,
              textAlign: TextAlign.justify,
            ),
            MethodHelper.heightBox(height: 5.h),
            SizedBox(
              width: 50.w,
              child: PrimaryBtn(
                  btnText: "Book Appointment",
                  borderRadius: BorderRadius.circular(AppSizes.size10),
                  textStyle: TextSizeHelper.smallTextStyle
                      .copyWith(color: AppColors.whiteColor),
                  onTap: () {
                    // logic to send user to appointment page
                  }),
            ),
            MethodHelper.heightBox(height: 3.h),
            const InScreenHeading(heading: "Videos"),
            SizedBox(
              height: 20.h,
              child: ListView.separated(
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: AppSizes.size10,
                  );
                },
                itemBuilder: (context, index) {
                  return CustomContainer(
                    width: 80.w,
                    margin: EdgeInsets.symmetric(vertical: AppSizes.size10),
                    backGroundColor: AppColors.lightBackGroundColor,
                    borderColor: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    borderWidth: 1,
                  );
                },
              ),
            ),
            MethodHelper.heightBox(height: 3.h),
            const InScreenHeading(heading: "Article"),
            SizedBox(
              height: 20.h,
              child: ListView.separated(
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: AppSizes.size10,
                  );
                },
                itemBuilder: (context, index) {
                  return CustomContainer(
                    width: 80.w,
                    margin: EdgeInsets.symmetric(vertical: AppSizes.size10),
                    backGroundColor: AppColors.lightBackGroundColor,
                    borderColor: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    borderWidth: 1,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
