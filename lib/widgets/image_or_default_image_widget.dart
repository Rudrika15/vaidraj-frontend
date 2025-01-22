import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ImageOrDefaultImage extends StatelessWidget {
  const ImageOrDefaultImage(
      {super.key, required this.image, this.widthAndHeight});

  final String image;
  final double? widthAndHeight;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "assets/images/no-image-found.png",
        width: widthAndHeight ?? 10.w,
        height: widthAndHeight ?? 10.w,
        fit: BoxFit.contain,
      ),
      fit: BoxFit.cover,
    );
  }
}
