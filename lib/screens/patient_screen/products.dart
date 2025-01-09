import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_searchbar.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.size10,
                  mainAxisSpacing: AppSizes.size10),
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ProductTempletContainer();
              },
            ),
          ),
        )
      ],
    ));
  }
}

class ProductTempletContainer extends StatelessWidget {
  const ProductTempletContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 40.w,
      borderColor: AppColors.brownColor,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(AppSizes.size10),
      child: const Column(
        children: [
          Expanded(
            flex: 8,
            child: CustomContainer(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.size10),
                  topRight: Radius.circular(AppSizes.size10)),
              image: DecorationImage(
                image: AssetImage("assets/images/pain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    "Rheumatoid",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    r"$ 5900",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
