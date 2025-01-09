import 'package:flutter/material.dart';

import '../constants/color.dart';

class GreenDividerLine extends StatelessWidget {
  const GreenDividerLine({
    super.key,
    required this.endIndent,
    required this.indent,
  });
  final double? indent;
  final double? endIndent;
  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 2,
      color: AppColors.greenColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}