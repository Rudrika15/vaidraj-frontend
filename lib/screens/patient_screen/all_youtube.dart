import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../constants/strings.dart';
import '../../constants/text_size.dart';
import '../../models/youtube_video_model.dart';
import '../../provider/localization_provider.dart';
import '../../services/youtube_video_service/youtube_video_service.dart';
import '../../utils/method_helper.dart';
import '../../widgets/Custom_video_player.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/image_or_default_image_widget.dart';
import '../../widgets/loader.dart';

class AllYouTubeVideos extends StatefulWidget {
  const AllYouTubeVideos({super.key});

  @override
  State<AllYouTubeVideos> createState() => _AllYouTubeVideosState();
}

class _AllYouTubeVideosState extends State<AllYouTubeVideos> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => SafeArea(
          child: langProvider.isLoading
              ? Center(child: Loader())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CustomSearchBar(),
                    Expanded(
                        child: StreamBuilder(
                      stream: langProvider.localeStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Loader(),
                          );
                        } else {
                          bool isEnglish = snapshot.data == "en";
                          return isEnglish
                              ? RenderYouTubeVideos()
                              : RenderYouTubeVideos();
                        }
                      },
                    )),
                  ],
                )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RenderYouTubeVideos extends StatefulWidget {
  const RenderYouTubeVideos({super.key});

  @override
  State<RenderYouTubeVideos> createState() => _RenderSpecialityState();
}

class _RenderSpecialityState extends State<RenderYouTubeVideos>
    with NavigateHelper {
  final PagingController<int, YoutubeVideoInfo> _pagingController =
      PagingController(firstPageKey: 1);
  final YouTubeVideoService service = YouTubeVideoService();
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
      YoutubeVideoModel? newItems = await service.getAllYouTubeVideo(
          context: context, currentPage: pageKey, perPage: 3);
      final isLastPage = ((newItems?.data?.data?.length ?? 0) < 3);
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
    return CustomContainer(
      child: PagedListView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size20, vertical: AppSizes.size10),
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<YoutubeVideoInfo>(
            noItemsFoundIndicatorBuilder: (context) => CustomContainer(
                alignment: Alignment.center,
                //// will show to let user start controller again
                child: GestureDetector(
                  onTap: () async {
                    _pagingController.refresh();
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
            itemBuilder: (context, item, index) => CustomContainer(
                width: 90.w,
                margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
                backGroundColor: AppColors.lightBackGroundColor,
                borderColor: AppColors.brownColor,
                borderRadius: BorderRadius.circular(AppSizes.size10),
                borderWidth: 1,
                child: GestureDetector(
                    onTap: () {
                      if (item.youtubeLink?.contains("<iframe") ?? false) {
                        push(
                            context,
                            CustomVideoPlayer(
                              videoLink: MethodHelper.extractVideoId(
                                iframeEmbedUrl: item.youtubeLink ?? "",
                              ),
                              heading: item.displayName ?? "",
                              description:
                                  item.disease?.displayDescription ?? "",
                            ));
                      } else {
                        push(
                            context,
                            CustomVideoPlayer(
                              videoLink: YoutubePlayer.convertUrlToId(
                                      item.youtubeLink ?? "") ??
                                  "",
                              heading: item.displayName ?? "",
                              description:
                                  item.disease?.displayDescription ?? "",
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
                                  "${AppStrings.thumbnailPhotoUrl}/${item.thumbnail ?? ""}"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(
                            item.displayName ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextSizeHelper.smallHeaderStyle
                                .copyWith(color: AppColors.brownColor),
                          ),
                        )
                      ],
                    ))),
          )),
    );
  }
}
