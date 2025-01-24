import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/services/all_disease_service/all_disease_service.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';
import 'package:vaidraj/widgets/loader.dart';

class SpecialitiesScreen extends StatefulWidget {
  const SpecialitiesScreen({super.key});

  @override
  State<SpecialitiesScreen> createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {
  // variables
  static const _pageSize = 5;
  AllDiseaseService diseaseService = AllDiseaseService();
  final PagingController<int, Diseases> _pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(
        pageKey: pageKey,
      );
    });
  }

  Future<void> _fetchPage({
    required int pageKey,
  }) async {
    try {
      final newItems = await diseaseService.getDiseaseByPage(
        context: context,
        currentPage: pageKey,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        CustomSearchBar(),
        PagedGridView(
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
              itemBuilder: (context, item, index) => SpecialityTempletContainer(
                image: "${AppStrings.dieasesPhotoUrl}/${item.thumbnail ?? ""}",
                title: item.displayName ?? "",
                description: item.displayDescription ?? "",
                videos: item.videos ?? [],
                articles: item.articles ?? [],
              ),
            )),
      ],
    ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
