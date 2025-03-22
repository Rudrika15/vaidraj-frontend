import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/services/article_service.dart/article_service.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../constants/strings.dart';
import '../../models/article_model.dart';
import '../../provider/localization_provider.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/image_or_default_image_widget.dart';
import '../../widgets/loader.dart';
import '../../widgets/webview_widget.dart';
import '../home/home_screen.dart';

class AllArticlePage extends StatefulWidget {
  const AllArticlePage({super.key});

  @override
  State<AllArticlePage> createState() => _AllYouTubeVideosState();
}

class _AllYouTubeVideosState extends State<AllArticlePage> with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // will send user to my property page on back btn press
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        String role = await SharedPrefs.getRole();
        pushRemoveUntil(
            context,
            HomeScreen(
              isAdmin: role == "admin",
              isDoctor: role == "doctor",
              screenIndex: 0,
            ));
      },
      child: Consumer<LocalizationProvider>(
        builder: (context, langProvider, child) => SafeArea(
            child: langProvider.isLoading
                ? Center(child: Loader())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CustomSearchBar(),
                      Expanded(
                          child: RefreshIndicator(
                        onRefresh: () async {
                          Future.delayed(Duration(seconds: 1));
                        },
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
                                  ? RenderAllArticle()
                                  : RenderAllArticle();
                            }
                          },
                        ),
                      )),
                    ],
                  )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RenderAllArticle extends StatefulWidget {
  const RenderAllArticle({super.key});

  @override
  State<RenderAllArticle> createState() => _RenderSpecialityState();
}

class _RenderSpecialityState extends State<RenderAllArticle>
    with NavigateHelper {
  final PagingController<int, ArticleInfo> _pagingController =
      PagingController(firstPageKey: 1);
  final ArticleService service = ArticleService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      _pagingController.addPageRequestListener((pageKey) {
        fetchPage(pageKey: pageKey, context: context);
      });
    } else {
      // print('nope');
    }
  }

  Future<void> fetchPage(
      {required int pageKey, required BuildContext context}) async {
    try {
      print(pageKey);
      ArticleModel? newItems = await service.getAllArticle(
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
          builderDelegate: PagedChildBuilderDelegate<ArticleInfo>(
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
            itemBuilder: (context, item, index) {
              print(item.thumbnail);
              print(item.url);
              return GestureDetector(
                onTap: () => push(
                    context,
                    WebViewScreen(
                      uri: item.url ?? "",
                      diseaseName: item.disease?.displayName ?? "",
                    )),
                child: CustomContainer(
                  width: 90.w,
                  height: 25.h,
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
                  backGroundColor: AppColors.lightBackGroundColor,
                  borderColor: AppColors.brownColor,
                  borderRadius: BorderRadius.circular(AppSizes.size10),
                  borderWidth: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.size10),
                    child: ImageOrDefaultImage(
                      image: "${AppStrings.articlePhotoUrl}/${item.thumbnail}",
                    ),
                  ),
                  // child: ,
                ),
              );
            },
          )),
    );
  }
}
