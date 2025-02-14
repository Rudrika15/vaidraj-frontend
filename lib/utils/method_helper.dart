import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Request storage permission
  static Future<bool> requestStoragePermission(BuildContext context) async {
    // Check for Permission.storage status (Normal storage for Android < 12)
    var status = await Permission.storage.status;
    print('status on init = ${status.isGranted}');
    if (status.isGranted) {
      print("Storage permission is already granted.");
      return true;
    }

    // If not granted, check if Android version is >= 12 and request Permission.manageExternalStorage
    if (Platform.isAndroid && status.isDenied) {
      var isGranted = await Permission.manageExternalStorage.request();
      if (isGranted.isGranted) {
        print("MANAGE_EXTERNAL_STORAGE permission granted.");
        return true;
      } else {
        print("MANAGE_EXTERNAL_STORAGE permission denied.");
        return false;
      }
    }

    // For older Android versions, request normal storage permission
    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        print("Storage permission granted.");
        return true;
      } else {
        print("Storage permission denied.");
        return false;
      }
    }

    // Handle the case when permission is permanently denied
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  static bool isToday(String dateString) {
    // Parse the given date string into a DateTime object
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);

    // Get the current date (only year, month, and day, no time)
    DateTime today = DateTime.now();

    // Compare the year, month, and day of the date and today's date
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  /// calculate age by birthdate
  static int calculateAge({required String birthDateString}) {
    // Parse the date string into a DateTime object

    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in years
    int age = currentDate.year - birthDate.year;

    // Adjust if the birth date hasn't occurred yet this year
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
