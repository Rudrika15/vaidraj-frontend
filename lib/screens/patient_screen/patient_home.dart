import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/models/upcoming_appointment_model.dart';
import 'package:vaidraj/models/youtube_video_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/view_product_or_appointment.dart';
import 'package:vaidraj/services/all_disease_service/all_disease_service.dart';
import 'package:vaidraj/services/appointment/upcoming_appointment.dart';
import 'package:vaidraj/services/youtube_video_service/youtube_video_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/Custom_video_player.dart';
import '../../widgets/custom_exit_dialog_widget.dart';
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
  Widget build(BuildContext pContext) {
    /// this will prevent app from closing accidentetly
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        showDialog(
            context: context,
            builder: (context) => CustomAlertBox(
                content: "Do you really want to exit?",
                heading: "Exit App",
                secondBtnText: "Exit",
                onPressedSecondBtn: () => SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop')));
      },
      child: Consumer<LocalizationProvider>(
        builder: (context, langProvider, child) => SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(

              //   padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              //   child: CustomSearchBar(
              //     hintText: langProvider.translate("searchHere"),
              //     horizontal: 0,
              //   ),
              // ),
              InScreenHeading(
                heading: langProvider.translate("ourSpeciality"),
              ),
              //// on lang change will discard the current speciality widget and use a new one
              StreamBuilder(
                stream: langProvider.localeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Loader());
                  } else {
                    bool isEnglish = snapshot.data == "en";
                    return isEnglish
                        ? SpecialitiesRenderWidget()
                        : SpecialitiesRenderWidget();
                  }
                },
              ),
              InScreenHeading(heading: langProvider.translate("appointment")),

              /// render appointment
              RenderUpcomingAppointment(),
              InScreenHeading(
                  heading: langProvider.translate("recommendedVideos")),
              StreamBuilder(
                stream: langProvider.localeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Loader());
                  } else {
                    bool isEnglish = snapshot.data == "en";
                    return isEnglish
                        ? RenderYoutubeVideos()
                        : RenderYoutubeVideos();
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class RenderUpcomingAppointment extends StatelessWidget {
  final UpcomingAppointmentService upcomingAppointmentService =
      UpcomingAppointmentService();

  RenderUpcomingAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpcomingAppointmentModel?>(
      future: upcomingAppointmentService.upcomingAppointment(context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show loading spinner
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data?.data == null) {
          return Center(child: Text('Failed to load appointments'));
        }

        List<UpcomingAppointmentInfo> appointments =
            snapshot.data?.data?.data ?? [];

        return snapshot.data?.data?.data?.isEmpty == true
            ? SizedBox(
                height: 10.h,
                child: const ContainerForNoDataFound(title: "No Data Found"))
            : SizedBox(
                height: 20.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                  itemBuilder: (context, index) {
                    UpcomingAppointmentInfo appointment = appointments[index];
                    return CustomContainer(
                      margin:
                          const EdgeInsets.symmetric(vertical: AppSizes.size10),
                      padding: const EdgeInsets.all(AppSizes.size10),
                      width: 80.w,
                      height: 20.h,
                      backGroundColor: AppColors.lightBackGroundColor,
                      borderColor: AppColors.brownColor,
                      borderRadius: BorderRadius.circular(AppSizes.size10),
                      borderWidth: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.name ?? 'Unknown',
                                  style: TextSizeHelper.smallHeaderStyle,
                                ),
                              ),
                              Text(
                                appointment.date ?? 'No date',
                                style: TextSizeHelper.smallTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${appointment.status}".toUpperCase(),
                                style: TextSizeHelper.xSmallHeaderStyle
                                    .copyWith(
                                        color: appointment.status == "completed"
                                            ? AppColors.greenColor
                                            : AppColors.errorColor),
                              ),
                            ],
                          ),
                          MethodHelper.heightBox(height: 1.h),
                          Text(
                            "Appointment Slot : ${appointment.slot}",
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          Text(
                            "Subject  : ${appointment.subject}",
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          Text(
                            "Message : ${appointment.message}",
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      MethodHelper.widthBox(width: 2.w),
                  itemCount: appointments.length,
                ),
              );
      },
    );
  }
}

class SpecialitiesRenderWidget extends StatefulWidget {
  const SpecialitiesRenderWidget({super.key});

  @override
  State<SpecialitiesRenderWidget> createState() =>
      _SpecialitiesRenderWidgetState();
}

class _SpecialitiesRenderWidgetState extends State<SpecialitiesRenderWidget> {
  /// variable
  final PagingController<int, Diseases> _pagingController =
      PagingController(firstPageKey: 1);
  final AllDiseaseService service = AllDiseaseService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      _pagingController.addPageRequestListener((pageKey) {
        fetchPage(pageKey: pageKey, context: context);
      });
    } else {
      print('nope');
    }
  }

  Future<void> fetchPage(
      {required int pageKey, required BuildContext context}) async {
    try {
      print(pageKey);
      AllDieseasesModel? newItems = await service.getDieases(
        context: context,
        currentPage: pageKey,
      );
      final isLastPage = ((newItems?.data?.data?.length ?? 0) < 5);
      if (isLastPage) {
        _pagingController.appendLastPage(newItems?.data?.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems?.data?.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                scrollDirection: Axis.horizontal,
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Diseases>(
                  firstPageErrorIndicatorBuilder: (context) =>
                      PrimaryBtn(btnText: "Reload", onTap: () {}),
                  noItemsFoundIndicatorBuilder: (context) => CustomContainer(
                      alignment: Alignment.center,
                      //// will show to let user start controller again
                      child: GestureDetector(
                        onTap: () async {
                          _pagingController.refresh();
                        },
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
                    foodPlan: diseases.displayFoodPlan ?? "",
                  ),
                ),
                separatorBuilder: (context, index) => MethodHelper.widthBox(
                      width: AppSizes.size10,
                    ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }
}

class SpecialityTempletContainer extends StatelessWidget {
  const SpecialityTempletContainer(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.videos,
      required this.articles,
      required this.foodPlan});
  final String title;
  final String image;
  final String description;
  final List<Videos>? videos;
  final List<Articles>? articles;
  final String foodPlan;
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
                foolPlan: foodPlan,
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

class RenderYoutubeVideos extends StatefulWidget {
  const RenderYoutubeVideos({super.key});

  @override
  State<RenderYoutubeVideos> createState() => _RenderYoutubeVideosState();
}

class _RenderYoutubeVideosState extends State<RenderYoutubeVideos>
    with NavigateHelper {
  final YouTubeVideoService service = YouTubeVideoService();
  YoutubeVideoModel? model;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getYoutubeVideo();
  }

  Future<void> getYoutubeVideo() async {
    model = await service.getYouTubeVideo(context);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Loader(),
          )
        : SizedBox(
            height: 30.h,
            child: ListView.separated(
              itemCount: model?.data?.data?.length ?? 0,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: AppSizes.size10,
                );
              },
              itemBuilder: (context, index) {
                YoutubeVideoInfo? ytInfo = model?.data?.data?[index];
                return CustomContainer(
                    width: 90.w,
                    margin: const EdgeInsets.symmetric(
                        vertical: AppSizes.size10, horizontal: 5),
                    backGroundColor: AppColors.lightBackGroundColor,
                    borderColor: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    borderWidth: 1,
                    child: GestureDetector(
                        onTap: () {
                          if (ytInfo?.youtubeLink?.contains("<iframe") ??
                              false) {
                            push(
                                context,
                                CustomVideoPlayer(
                                  videoLink: MethodHelper.extractVideoId(
                                    iframeEmbedUrl: ytInfo?.youtubeLink ?? "",
                                  ),
                                  heading: ytInfo?.displayName ?? "",
                                  description:
                                      ytInfo?.disease?.displayDescription ?? "",
                                ));
                          } else {
                            push(
                                context,
                                CustomVideoPlayer(
                                  videoLink: YoutubePlayer.convertUrlToId(
                                          ytInfo?.youtubeLink ?? "") ??
                                      "",
                                  heading: ytInfo?.displayName ?? "",
                                  description:
                                      ytInfo?.disease?.displayDescription ?? "",
                                ));
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppSizes.size10),
                                  topRight: Radius.circular(AppSizes.size10)),
                              child: ImageOrDefaultImage(
                                  image:
                                      "${AppStrings.thumbnailPhotoUrl}/${ytInfo?.thumbnail ?? ""}"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: Text(
                                ytInfo?.displayName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextSizeHelper.smallHeaderStyle
                                    .copyWith(color: AppColors.brownColor),
                              ),
                            )
                          ],
                        )));
              },
            ),
          );
  }
}
