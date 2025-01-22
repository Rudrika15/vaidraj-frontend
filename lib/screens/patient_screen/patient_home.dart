import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/view_product_or_appointment.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../widgets/custom_searchbar.dart';
import '../../widgets/image_or_default_image_widget.dart';
import '../../widgets/in_app_heading.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var diseaseProvider =
        Provider.of<AllDiseaseProvider>(context, listen: false);
    if (diseaseProvider.diseaseModel == null) {
      diseaseProvider.getAllDisease(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocalizationProvider, AllDiseaseProvider>(
      builder: (context, langProvider, diseaseProvider, child) => SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              child: CustomSearchBar(
                hintText: langProvider.translate("searchHere"),
                horizontal: 0,
              ),
            ),
            InScreenHeading(
              heading: langProvider.translate("ourSpeciality"),
            ),
            SpecialitiesRenderWidget(
              diseaseProvider: diseaseProvider,
            ),
            InScreenHeading(heading: langProvider.translate("appointment")),
            CustomContainer(
              margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
              width: 90.w,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: AppSizes.size10,
                );
              },
              itemBuilder: (context, index) {
                return CustomContainer(
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
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
  const SpecialitiesRenderWidget({super.key, required this.diseaseProvider});
  final AllDiseaseProvider diseaseProvider;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
      child: SizedBox(
        height: 15.h,
        child: diseaseProvider.isLoading
            ? const Center(
                child: Loader(),
              )
            : ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: AppSizes.size10,
                  );
                },
                itemCount:
                    diseaseProvider.diseaseModel?.data?.data?.length ?? 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                itemBuilder: (context, index) {
                  Diseases? diseases =
                      diseaseProvider.diseaseModel?.data?.data?[index];
                  return SpecialityTempletContainer(
                    title: diseases?.displayName ?? "",
                    image:
                        "${AppStrings.dieasesPhotoUrl}/${diseases?.thumbnail ?? ""}",
                    description: diseases?.displayDescription ?? "",
                    videos: diseases?.videos ?? [],
                    articles: diseases?.articles ?? [],
                  );
                },
              ),
      ),
    );
  }
}

class SpecialityTempletContainer extends StatelessWidget {
  const SpecialityTempletContainer(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.videos,
      required this.articles});
  final String title;
  final String image;
  final String description;
  final List<Videos>? videos;
  final List<Articles>? articles;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewProductOrAppointment(
                title: title,
                image: image,
                description: description,
                videos: videos,
                articles: articles,
              ))),
      child: CustomContainer(
        width: 29.w,
        borderColor: AppColors.brownColor,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(AppSizes.size10),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CustomContainer(
                  padding: const EdgeInsets.all(0),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.size10),
                      topRight: Radius.circular(AppSizes.size10)),
                  image: MethodHelper.imageOrNoImage(image: image)),
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
