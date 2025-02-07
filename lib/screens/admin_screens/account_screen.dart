import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/screens/mobile_verification/mobile_verification.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_exit_dialog_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../home/home_screen.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage>
    with NavigateHelper {
  String? userName;
  String? email;
  String? phoneNumber;

  Future<void> getUserInfo() async {
    userName = await SharedPrefs.getName();
    email = await SharedPrefs.getEmail();
    phoneNumber = await SharedPrefs.getMobileNumber();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        String role = await SharedPrefs.getRole();
        pushRemoveUntil(
          context,
          HomeScreen(
            isAdmin: role == "admin",
            isDoctor: role == "doctor",
            screenIndex: 2,
          ),
        );
      },
      child: CustomContainer(
        width: 100.w,
        backGroundColor:
            AppColors.whiteColor, // A white background to separate content
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              child: Column(
                children: [
                  // Avatar with border and gradient
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.greenColor,
                            AppColors.backgroundColor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          MethodHelper.getInitials(name: userName ?? ""),
                          style: TextSizeHelper.mediumHeaderStyle.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  MethodHelper.heightBox(height: 4.h),
                  // User name with styling
                  Text(
                    userName ?? "",
                    style: TextSizeHelper.mediumHeaderStyle
                        .copyWith(color: AppColors.brownColor),
                  ),
                  MethodHelper.heightBox(height: 1.h),
                  // Phone number with a more muted text style
                  Text(
                    phoneNumber ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            MethodHelper.heightBox(height: 2.h),

            // Modern Logout Button
            SizedBox(
              width: 50.w,
              child: PrimaryBtn(
                btnText: "Logout",
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => CustomAlertBox(
                    content: "Do You Really Want To Logout?",
                    heading: "Are You Sure?",
                    secondBtnText: "LogOut",
                    color: AppColors.errorColor,
                    onPressedSecondBtn: () async {
                      await SharedPrefs.clearShared();
                      pushRemoveUntil(context, MobileVerification());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
