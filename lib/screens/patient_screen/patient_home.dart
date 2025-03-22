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
import '../../widgets/image_or_default_image_widget.dart';
import '../../widgets/in_app_heading.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  /// Store data to pass to widgets after refresh
  List<dynamic> _allData = [];
  bool _isLoading = true;
  final PagingController<int, Diseases> pagingController =
      PagingController(firstPageKey: 1);
  final AllDiseaseService service = AllDiseaseService();

  /// Load all data in one Future
  Future<void> loadAllData() async {
    try {
      final results = await Future.wait([
        UpcomingAppointmentService().upcomingAppointment(context: context),
        YouTubeVideoService().getYouTubeVideo(context),
      ]);
      setState(() {
        _allData = results;
        _isLoading = false;
      });
    } catch (e) {
      // print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPagination();
    loadAllData();
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
        pagingController.appendLastPage(newItems?.data?.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems?.data?.data ?? [], nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> initPagination() async {
    if (mounted) {
      pagingController.addPageRequestListener((pageKey) {
        fetchPage(pageKey: pageKey, context: context);
      });
    } else {
      // print('nope');
    }
  }

  @override
  Widget build(BuildContext pContext) {
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
      child: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brownColor,
          backgroundColor: AppColors.whiteColor,
          onRefresh: () async {
            setState(() {
              _isLoading = true;
            });
            await initPagination();
            await loadAllData();
          },
          child: _isLoading
              ? const Center(child: Loader())
              : ListView(
                  children: [
                    /// Specialities Section
                    InScreenHeading(
                        heading: context
                            .watch<LocalizationProvider>()
                            .translate("ourSpeciality")),
                    SpecialitiesRenderWidget(
                      pagingController: pagingController,
                    ),

                    /// Appointment Section
                    InScreenHeading(
                        heading: context
                            .watch<LocalizationProvider>()
                            .translate("appointment")),
                    RenderUpcomingAppointment(
                        appointmentData: _allData[0]?.data?.data ?? []),

                    /// Recommended Videos Section
                    InScreenHeading(
                        heading: context
                            .watch<LocalizationProvider>()
                            .translate("recommendedVideos")),
                    RenderYoutubeVideos(
                        videoData: _allData[1]?.data?.data ?? []),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pagingController.dispose();
  }
}

class SpecialitiesRenderWidget extends StatefulWidget {
  SpecialitiesRenderWidget({
    super.key,
    required this.pagingController,
  });
  PagingController<int, Diseases> pagingController;
  @override
  State<SpecialitiesRenderWidget> createState() =>
      _SpecialitiesRenderWidgetState();
}

class _SpecialitiesRenderWidgetState extends State<SpecialitiesRenderWidget> {
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
                pagingController: widget.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Diseases>(
                  firstPageErrorIndicatorBuilder: (context) =>
                      PrimaryBtn(btnText: "Reload", onTap: () {}),
                  noItemsFoundIndicatorBuilder: (context) => CustomContainer(
                      alignment: Alignment.center,
                      //// will show to let user start controller again
                      child: GestureDetector(
                        onTap: () async {
                          widget.pagingController.refresh();
                        },
                        child: const CustomContainer(
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
                    diseaseId: diseases.id ?? -1,
                  ),
                ),
                separatorBuilder: (context, index) => MethodHelper.widthBox(
                      width: AppSizes.size10,
                    ))));
  }
}

class RenderUpcomingAppointment extends StatelessWidget {
  final List<UpcomingAppointmentInfo> appointmentData;
  const RenderUpcomingAppointment({super.key, required this.appointmentData});

  @override
  Widget build(BuildContext context) {
    List<UpcomingAppointmentInfo> appointments =
        appointmentData.where((e) => e.status != "completed").toList();

    return appointments.isNotEmpty
        ? SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              itemBuilder: (context, index) {
                UpcomingAppointmentInfo appointment = appointments[index];
                return CustomContainer(
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
                  padding: const EdgeInsets.all(AppSizes.size10),
                  width: 90.w,
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
                            style: TextSizeHelper.xSmallHeaderStyle.copyWith(
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
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: SizedBox(
              height: 10.h,
              child:
                  const ContainerForNoDataFound(title: "No Appointment Found"),
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
      required this.articles,
      required this.foodPlan,
      required this.diseaseId});
  final String title;
  final String image;
  final String description;
  final List<Videos>? videos;
  final List<Articles>? articles;
  final String foodPlan;
  final int diseaseId;
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
                diseaseId: diseaseId,
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

class RenderYoutubeVideos extends StatelessWidget with NavigateHelper {
  final List<YoutubeVideoInfo> videoData;
  const RenderYoutubeVideos({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return videoData.isNotEmpty
        ? SizedBox(
            height: 30.h,
            child: ListView.separated(
              itemCount: videoData.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: AppSizes.size10,
                );
              },
              itemBuilder: (context, index) {
                YoutubeVideoInfo? ytInfo = videoData[index];
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
                          if (ytInfo.youtubeLink?.contains("<iframe") ??
                              false) {
                            push(
                                context,
                                CustomVideoPlayer(
                                  videoLink: MethodHelper.extractVideoId(
                                    iframeEmbedUrl: ytInfo.youtubeLink ?? "",
                                  ),
                                  heading: ytInfo.displayName ?? "",
                                  description:
                                      ytInfo.disease?.displayDescription ?? "",
                                ));
                          } else {
                            push(
                                context,
                                CustomVideoPlayer(
                                  videoLink: YoutubePlayer.convertUrlToId(
                                          ytInfo.youtubeLink ?? "") ??
                                      "",
                                  heading: ytInfo.displayName ?? "",
                                  description:
                                      ytInfo.disease?.displayDescription ?? "",
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
                                      "${AppStrings.thumbnailPhotoUrl}/${ytInfo.thumbnail ?? ""}"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: Text(
                                ytInfo.displayName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextSizeHelper.smallHeaderStyle
                                    .copyWith(color: AppColors.brownColor),
                              ),
                            )
                          ],
                        )));
              },
            ),
          )
        : SizedBox(
            height: 20.h,
            child: const Center(
                child: ContainerForNoDataFound(title: "No Data Found")));
  }
}
