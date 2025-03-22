import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/appointment.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/Custom_video_player.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/image_or_default_image_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import 'package:vaidraj/widgets/webview_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../constants/color.dart';
import '../../constants/text_size.dart';
import '../../models/all_disease_model.dart';
import '../../widgets/in_app_heading.dart';

class ViewProductOrAppointment extends StatefulWidget {
  const ViewProductOrAppointment(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.foolPlan,
      required this.videos,
      required this.articles,
      required this.diseaseId});
  final String title;
  final String image;
  final String description;
  final String foolPlan;
  final List<Videos>? videos;
  final List<Articles>? articles;
  final int diseaseId;
  @override
  State<ViewProductOrAppointment> createState() =>
      _ViewProductOrAppointmentState();
}

class _ViewProductOrAppointmentState extends State<ViewProductOrAppointment>
    with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.whiteColor,
          title: Text(
            widget.title,
            style: TextSizeHelper.mediumTextStyle
                .copyWith(color: AppColors.brownColor),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
          child: Column(
            children: [
              CustomContainer(
                borderRadius: BorderRadius.circular(AppSizes.size10),
                borderColor: AppColors.brownColor,
                height: 25.h,
                width: 90.w,
                child: CustomContainer(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.size10),
                      child: ImageOrDefaultImage(
                        image: widget.image,
                      )),
                ),
              ),
              MethodHelper.heightBox(height: 3.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: Text(
                  widget.description,
                  style: TextSizeHelper.smallTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
              MethodHelper.heightBox(height: 3.h),
              InScreenHeading(heading: langProvider.translate('foodPlan')),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: Text(
                  widget.foolPlan,
                  style: TextSizeHelper.smallTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
              MethodHelper.heightBox(height: 5.h),
              SizedBox(
                width: 50.w,
                child: PrimaryBtn(
                    btnText: langProvider.translate('bookAppointment'),
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    textStyle: TextSizeHelper.smallTextStyle
                        .copyWith(color: AppColors.whiteColor),
                    onTap: () {
                      // logic to send user to appointment page
                      push(
                          context,
                          Appointment(
                            fromPage: true,
                            diseaseId: widget.diseaseId,
                          ));
                    }),
              ),
              if (widget.videos?.isNotEmpty ?? true) ...[
                MethodHelper.heightBox(height: 3.h),
                InScreenHeading(heading: langProvider.translate("videos")),
                SizedBox(
                  height: 25.h,
                  child: ListView.separated(
                    itemCount: widget.videos?.length ?? 0,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: AppSizes.size10),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: AppSizes.size10,
                      );
                    },
                    itemBuilder: (context, index) {
                      Videos? video = widget.videos?[index];
                      return CustomContainer(
                          width: 90.w,
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSizes.size10),
                          backGroundColor: AppColors.lightBackGroundColor,
                          borderColor: AppColors.brownColor,
                          borderRadius: BorderRadius.circular(AppSizes.size10),
                          borderWidth: 1,
                          child: GestureDetector(
                              onTap: () {
                                if (video?.thumbnail?.contains("<iframe") ??
                                    false) {
                                  push(
                                      context,
                                      CustomVideoPlayer(
                                        videoLink: MethodHelper.extractVideoId(
                                          iframeEmbedUrl:
                                              video?.youtubeLink ?? "",
                                        ),
                                        heading: video?.title ?? "",
                                        description: widget.description,
                                      ));
                                } else {
                                  push(
                                      context,
                                      CustomVideoPlayer(
                                        videoLink: YoutubePlayer.convertUrlToId(
                                                video?.youtubeLink ?? "") ??
                                            "",
                                        heading: video?.title ?? "",
                                        description: widget.description,
                                      ));
                                }
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.size10),
                                child: ImageOrDefaultImage(
                                    image:
                                        "${AppStrings.thumbnailPhotoUrl}/${video?.thumbnail ?? ""}"),
                              )));
                    },
                  ),
                ),
              ],
              if (widget.articles?.isNotEmpty ?? true) ...[
                MethodHelper.heightBox(height: 3.h),
                InScreenHeading(heading: langProvider.translate("article")),
                SizedBox(
                  height: 25.h,
                  child: ListView.separated(
                    itemCount: widget.articles?.length ?? 0,
                    padding: const EdgeInsets.only(left: AppSizes.size10),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: AppSizes.size10,
                      );
                    },
                    itemBuilder: (context, index) {
                      Articles? articles = widget.articles?[index];
                      return GestureDetector(
                        onTap: () => push(
                            context,
                            WebViewScreen(
                              uri: articles?.url ?? "",
                              diseaseName: widget.title,
                            )),
                        child: CustomContainer(
                          width: 90.w,
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSizes.size10),
                          backGroundColor: AppColors.lightBackGroundColor,
                          borderColor: AppColors.brownColor,
                          borderRadius: BorderRadius.circular(AppSizes.size10),
                          borderWidth: 1,
                          image: MethodHelper.imageOrNoImage(
                              image:
                                  "${AppStrings.articlePhotoUrl}/${articles?.thumbnail ?? ""}"),
                          // child: ,
                        ),
                      );
                    },
                  ),
                ),
                MethodHelper.heightBox(height: 3.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerForNoDataFound extends StatelessWidget {
  const ContainerForNoDataFound({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      alignment: Alignment.center,
      width: 90.w,
      borderColor: AppColors.brownColor,
      borderRadius: BorderRadius.circular(AppSizes.size10),
      borderWidth: 1,
      child: Text(
        title,
        style: TextSizeHelper.smallTextStyle,
      ),
    );
  }
}
