import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/screens/patient_screen/appointment.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/Custom_video_player.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/image_or_default_image_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

import '../../constants/color.dart';
import '../../constants/text_size.dart';
import '../../widgets/in_app_heading.dart';

class ViewProductOrAppointment extends StatelessWidget with NavigateHelper {
  const ViewProductOrAppointment(
      {super.key,
      required this.title,
      required this.image,
      required this.description});
  final String title;
  final String image;
  final String description;
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
              width: 90.w,
              child: CustomContainer(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    child: ImageOrDefaultImage(
                      image: image,
                    )),
              ),
            ),
            MethodHelper.heightBox(height: 3.h),
            Text(
              description,
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
                    push(
                        context,
                        Appointment(
                          fromPage: true,
                        ));
                  }),
            ),
            MethodHelper.heightBox(height: 3.h),
            const InScreenHeading(heading: "Videos"),
            SizedBox(
              height: 25.h,
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
                    child: CustomVideoPlayer(
                        videoUrl:
                            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
                  );
                },
              ),
            ),
            MethodHelper.heightBox(height: 3.h),
            const InScreenHeading(heading: "Article"),
            SizedBox(
              height: 30.h,
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
