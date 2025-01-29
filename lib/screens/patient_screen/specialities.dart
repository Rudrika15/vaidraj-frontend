import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';
import 'package:vaidraj/widgets/loader.dart';

import '../../constants/color.dart';
import '../../services/all_disease_service/all_disease_service.dart';

class SpecialitiesScreen extends StatefulWidget {
  const SpecialitiesScreen({super.key});

  @override
  State<SpecialitiesScreen> createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => SafeArea(
          child: langProvider.isLoading
              ? Center(child: Loader())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSearchBar(),
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
                              ? RenderSpeciality()
                              : RenderSpeciality();
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

class RenderSpeciality extends StatefulWidget {
  const RenderSpeciality({super.key});

  @override
  State<RenderSpeciality> createState() => _RenderSpecialityState();
}

class _RenderSpecialityState extends State<RenderSpeciality> {
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
    return CustomContainer(
      child: PagedGridView(
          showNewPageErrorIndicatorAsGridChild: true,
          showNoMoreItemsIndicatorAsGridChild: true,
          showNewPageProgressIndicatorAsGridChild: true,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size20, vertical: AppSizes.size10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.size10,
              mainAxisSpacing: AppSizes.size10),
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Diseases>(
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
            itemBuilder: (context, item, index) => SpecialityTempletContainer(
              image: "${AppStrings.dieasesPhotoUrl}/${item.thumbnail ?? ""}",
              title: item.displayName ?? "",
              description: item.displayDescription ?? "",
              videos: item.videos ?? [],
              articles: item.articles ?? [],
            ),
          )),
    );
  }
}
