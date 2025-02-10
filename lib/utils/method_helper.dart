import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaidraj/constants/color.dart';

import '../constants/text_size.dart';
import 'border_helper/border_helper.dart';

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

  static InputDecoration greenUnderLineBorder({
    required String hintText,
    Widget? suffix,
    // required IconData prefixIcon,
    // Color? prefixColor
  }) {
    return BorderHelper.greenInputBorder.copyWith(
      hintText: hintText,
      counterText: "",
      hintStyle: TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
      // prefix: Icon(
      //   prefixIcon,
      //   color: prefixColor ?? AppColors.greenColor,
      // ),
      suffix: suffix,
    );
  }

  static InputDecoration brownUnderLineBorder(
      {required String hintText,
      Widget? suffix,
      IconData? prefixIcon,
      Color? prefixColor}) {
    return BorderHelper.inputBorder.copyWith(
      hintText: hintText,
      counterText: "",
      hintStyle: TextSizeHelper.smallTextStyle.copyWith(color: Colors.black),
      prefixIcon: Icon(
        prefixIcon,
        color: prefixColor ?? AppColors.greenColor,
      ),
      suffix: suffix,
    );
  }

  static String extractVideoId({required String iframeEmbedUrl}) {
    final regex = RegExp(r'\/embed\/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(iframeEmbedUrl);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    } else {
      throw ArgumentError('Invalid YouTube embed URL');
    }
  }

  static String getInitials({required String name}) {
    List<String> names = name.split(' ');
    // Split the full name
    // First letter of first name
    String firstNameInitial =
        names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    // First letter of last name
    String lastNameInitial = names.length > 1 && names[1].isNotEmpty
        ? names[1][0].toUpperCase()
        : '';

    return firstNameInitial + lastNameInitial;
  }

  static Future<void> dialNumber(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
