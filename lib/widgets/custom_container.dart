import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      this.alignment,
      this.child,
      this.constraints,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.borderColor,
      this.borderWidth,
      this.image,
      this.backGroundColor,
      this.borderRadius});
  final AlignmentGeometry? alignment;
  final Widget? child;
  final BoxConstraints? constraints;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;
  final DecorationImage? image;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      constraints: constraints,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 2,
          ),
          borderRadius: borderRadius,
          color: backGroundColor,
          image: image),
      child: child,
    );
  }
}
