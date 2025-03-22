import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/strings.dart';
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
