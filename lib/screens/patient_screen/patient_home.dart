import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/view_product_or_appointment.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import '../../widgets/custom_searchbar.dart';
import '../../widgets/in_app_heading.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.size20),
        child: Column(
          children: [
            CustomSearchBar(
              hintText: langProvider.translate("searchHere"),
              horizontal: 0,
            ),
            InScreenHeading(
              heading: langProvider.translate("ourSpeciality"),
            ),
            SpecialitiesRenderWidget(),
            InScreenHeading(heading: langProvider.translate("appointment")),
            CustomContainer(
              margin: EdgeInsets.symmetric(vertical: AppSizes.size10),
              height: 20.h,
              backGroundColor: AppColors.lightBackGroundColor,
              borderColor: AppColors.brownColor,
              borderRadius: BorderRadius.circular(AppSizes.size10),
              borderWidth: 1,
            ),
            InScreenHeading(
                heading: langProvider.translate("recommendedVideos")),
            ListView.separated(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: AppSizes.size10,
                );
              },
              itemBuilder: (context, index) {
                return CustomContainer(
                  margin: EdgeInsets.symmetric(vertical: AppSizes.size10),
                  height: 20.h,
                  backGroundColor: AppColors.lightBackGroundColor,
                  borderColor: AppColors.brownColor,
                  borderRadius: BorderRadius.circular(AppSizes.size10),
                  borderWidth: 1,
                );
              },
            )
          ],
        ),
      )),
    );
  }
}

class SpecialitiesRenderWidget extends StatelessWidget {
  const SpecialitiesRenderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
      child: SizedBox(
        height: 15.h,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: AppSizes.size10,
            );
          },
          itemCount: 10,
          padding: EdgeInsets.only(left: AppSizes.size10),
          itemBuilder: (context, index) {
            return SpecialityTempletContainer(
              title: "Rheumatoid",
              image: "",
            );
          },
        ),
      ),
    );
  }
}

class SpecialityTempletContainer extends StatelessWidget {
  const SpecialityTempletContainer(
      {super.key, required this.title, required this.image});
  final String title;
  final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewProductOrAppointment(
                title: title,
              ))),
      child: CustomContainer(
        width: 30.w,
        borderColor: AppColors.brownColor,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(AppSizes.size10),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CustomContainer(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.size10),
                    topRight: Radius.circular(AppSizes.size10)),
                image: DecorationImage(
                  image: image == ""
                      ? const AssetImage("assets/images/pain.jpg")
                      : NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
