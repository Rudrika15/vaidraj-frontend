import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/main.dart';
import 'package:vaidraj/provider/profile_provider.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/screens/welcome_page/welcome_page.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfileProvider(context: context);
    Future.delayed(
      const Duration(seconds: 2),
      () => guideScreen(),
    );
  }

  Future<bool> getToken() async {
    String? token = await SharedPrefs.getToken();
    // print("token from splash => $token");
    return token.isNotEmpty;
  }

  Future<String?> getRole() async {
    String? role = await SharedPrefs.getRole();
    // print("role from splash => $role");
    return role;
  }

  Future<void> initProfileProvider({required BuildContext context}) async {
    ProfileProvider profileProvider = context.read<ProfileProvider>();
    String? address = await SharedPrefs.getAddress();
    int? branchId = int.parse(await SharedPrefs.getBranchId());
    String? dob = await SharedPrefs.getDOB();
    String? email = await SharedPrefs.getEmail();
    int? id = int.parse(await SharedPrefs.getId());
    String? language = await SharedPrefs.getLanguage();
    String? mobileNo = await SharedPrefs.getMobileNumber();
    String? name = await SharedPrefs.getName();
    String? role = await SharedPrefs.getRole();
    profileProvider.setUserInfo(
        address: address,
        dob: dob,
        email: email,
        branchId: branchId,
        userId: id,
        language: language,
        mobileNo: mobileNo,
        name: name,
        role: role);
  }

  Future<void> guideScreen() async {
    bool token = await getToken();
    String? role = await getRole();

    if (token == true && role == "patient") {
      pushRemoveUntil(
          context,
          const HomeScreen(
            isDoctor: false,
            isAdmin: false,
          ));
      return;
    } else if (token == true && role == "admin") {
      pushRemoveUntil(
          context,
          const HomeScreen(
            isDoctor: false,
            isAdmin: true,
          ));
      return;
    } else if (token == true && role == "doctor" || role == "manager") {
      pushRemoveUntil(
          context,
          const HomeScreen(
            isDoctor: true,
            isAdmin: false,
          ));
      return;
    } else {
      pushRemoveUntil(context, const WelcomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image(
            fit: BoxFit.cover,
            width: 60.w,
            height: 30.h,
            image: const AssetImage(AppStrings.splashScreen)),
      ),
    );
  }
}
