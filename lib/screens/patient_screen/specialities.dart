import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';
import 'package:vaidraj/widgets/loader.dart';

class SpecialitiesScreen extends StatefulWidget {
  const SpecialitiesScreen({super.key});

  @override
  State<SpecialitiesScreen> createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AllDiseaseProvider>(
      builder: (context, diseaseProvider, child) => SafeArea(
          child: diseaseProvider.isLoading
              ? Center(child: Loader())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSearchBar(),
                    Expanded(
                      child: CustomContainer(
                        child: PagedGridView(
                            showNewPageErrorIndicatorAsGridChild: true,
                            showNoMoreItemsIndicatorAsGridChild: true,
                            showNewPageProgressIndicatorAsGridChild: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.size20,
                                vertical: AppSizes.size10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: AppSizes.size10,
                                    mainAxisSpacing: AppSizes.size10),
                            shrinkWrap: true,
                            pagingController: diseaseProvider.pagingController,
                            builderDelegate:
                                PagedChildBuilderDelegate<Diseases>(
                              itemBuilder: (context, item, index) =>
                                  SpecialityTempletContainer(
                                image:
                                    "${AppStrings.dieasesPhotoUrl}/${item.thumbnail ?? ""}",
                                title: item.displayName ?? "",
                                description: item.displayDescription ?? "",
                                videos: item.videos ?? [],
                                articles: item.articles ?? [],
                              ),
                            )),
                      ),
                    ),
                  ],
                )),
    );
  }

  @override
  void dispose() {
    // Provider.of<AllDiseaseProvider>(context, listen: false).pagingController.dispose();
    super.dispose();
  }
}
