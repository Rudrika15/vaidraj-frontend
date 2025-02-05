import 'package:flutter/material.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../home/home_screen.dart';

class AdminProfilePage extends StatelessWidget with NavigateHelper {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        // will send user to my property page on back btn press
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          String role = await SharedPrefs.getRole();
          pushRemoveUntil(
              context,
              HomeScreen(
                isAdmin: role == "admin",
                isDoctor: role == "doctor",
                screenIndex: 2,
              ));
        },
        child: const Placeholder());
  }
}
