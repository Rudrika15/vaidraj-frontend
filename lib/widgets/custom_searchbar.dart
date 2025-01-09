import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/sizes.dart';
import 'custom_container.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      this.horizontal = AppSizes.size20,
      this.vertical = AppSizes.size20,
      this.hintText,
      this.leading,
      this.trailing});
  final double horizontal;
  final double vertical;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: SearchBar(
        backgroundColor: WidgetStatePropertyAll(AppColors.lightBackGroundColor),
        hintText: hintText,
        leading: leading,
        trailing: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))
        ],
      ),
    );
  }
}
