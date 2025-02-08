import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/sizes.dart';
import 'custom_container.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.horizontal = AppSizes.size20,
    this.vertical = AppSizes.size20,
    this.hintText,
    this.leading,
    this.trailing,
    this.onSubmitted,
  });
  final double horizontal;
  final double vertical;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final void Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: SearchBar(
        onSubmitted: onSubmitted,
        backgroundColor:
            const WidgetStatePropertyAll(AppColors.lightBackGroundColor),
        hintText: hintText,
        leading: leading,
        trailing: [],
      ),
    );
  }
}
