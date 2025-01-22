import 'package:flutter/material.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    var diseasesProvider =
        Provider.of<AllDiseaseProvider>(context, listen: false);
    if (diseasesProvider.diseaseModel?.data?.data == null) {
      diseasesProvider.getAllDisease(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllDiseaseProvider>(
      builder: (context, diseaseProvider, child) => SafeArea(
          child: Column(
        children: [
          const CustomSearchBar(),
          Expanded(
            child: CustomContainer(
              child: diseaseProvider.isLoading
                  ? const Center(
                      child: Loader(),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20,
                          vertical: AppSizes.size10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: AppSizes.size10,
                              mainAxisSpacing: AppSizes.size10),
                      itemCount:
                          diseaseProvider.diseaseModel?.data?.data?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Diseases? diseases =
                            diseaseProvider.diseaseModel?.data?.data?[index];
                        return SpecialityTempletContainer(
                          image:
                              "${AppStrings.dieasesPhotoUrl}/${diseases?.thumbnail ?? ""}",
                          title: diseases?.displayName ?? "",
                          description: diseases?.displayDescription ?? "",
                        );
                      },
                    ),
            ),
          )
        ],
      )),
    );
  }
}
