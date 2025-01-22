import 'package:flutter/material.dart';

class MethodHelper {
  static SizedBox heightBox({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  static SizedBox widthBox({required double width}) {
    return SizedBox(
      width: width,
    );
  }
  static DecorationImage imageOrNoImage({required String image}) {
  return DecorationImage(
    image: NetworkImage(image),
    fit: BoxFit.cover,
    onError: (exception, stackTrace) =>
        AssetImage("assets/images/no-image-found.png"),
  );
}
}
