import 'package:flutter/material.dart';
import 'package:vaidraj/constants/color.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? AppColors.brownColor,
    );
  }
}
