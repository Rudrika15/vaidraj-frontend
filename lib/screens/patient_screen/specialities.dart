import 'package:flutter/material.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';

class SpecialitiesScreen extends StatelessWidget {
  const SpecialitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        CustomSearchBar(),
        Expanded(
          child: CustomContainer(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size20, vertical: AppSizes.size10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSizes.size10,
                  mainAxisSpacing: AppSizes.size10),
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SpecialityTempletContainer( image: "",title: "Rheumatoid",);
              },
            ),
          ),
        )
      ],
    ));
  }
}
