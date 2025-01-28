import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../widgets/custom_searchbar.dart';
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
    if (diseaseProvider.diseasesModel == null) {
      diseaseProvider.getAllDisease(context: context, currentPage: 0);
    }
  }

  @override
  Widget build(BuildContext pContext) {
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
            diseaseProvider.isLoading
                ? Loader()
                : SpecialitiesRenderWidget(
                    diseaseProvider: diseaseProvider,
                    pContext: context,
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

class SpecialitiesRenderWidget extends StatefulWidget {
  const SpecialitiesRenderWidget(
      {super.key, required this.diseaseProvider, required this.pContext});
  final AllDiseaseProvider diseaseProvider;
  final BuildContext pContext;
  @override
  State<SpecialitiesRenderWidget> createState() =>
      _SpecialitiesRenderWidgetState();
}

class _SpecialitiesRenderWidgetState extends State<SpecialitiesRenderWidget> {
  /// variable
  // final PagingController<int, Diseases> _pagingController =
  //     PagingController(firstPageKey: 1);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      widget.diseaseProvider.pagingController.addPageRequestListener((pageKey) {
        widget.diseaseProvider
            .fetchPage(pageKey: pageKey, context: widget.pContext);
      });
    } else {
      print('nope');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
        child: SizedBox(
          height: 16.h,
          child: PagedListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              scrollDirection: Axis.horizontal,
              pagingController: widget.diseaseProvider.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Diseases>(
                firstPageErrorIndicatorBuilder: (context) =>
                    PrimaryBtn(btnText: "Reload", onTap: () {}),
                noItemsFoundIndicatorBuilder: (context) => CustomContainer(
                    alignment: Alignment.center,
                    //// will show to let user start controller again
                    child: GestureDetector(
                      onTap: () => widget.diseaseProvider.setModelNull,
                      child: CustomContainer(
                        shape: BoxShape.circle,
                        child: Icon(
                          Icons.refresh_outlined,
                          color: AppColors.brownColor,
                          size: AppSizes.size40,
                        ),
                      ),
                    )),
                itemBuilder: (context, diseases, index) =>
                    SpecialityTempletContainer(
                  title: diseases.displayName ?? "",
                  image:
                      "${AppStrings.dieasesPhotoUrl}/${diseases.thumbnail ?? ""}",
                  description: diseases.displayDescription ?? "",
                  videos: diseases.videos ?? [],
                  articles: diseases.articles ?? [],
                ),
              ),
              separatorBuilder: (context, index) => MethodHelper.widthBox(
                    width: AppSizes.size10,
                  )),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _pagingController.dispose();
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
