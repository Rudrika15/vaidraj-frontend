import 'package:flutter/material.dart';
import 'package:vaidraj/services/mobile_verification/mobile_verification.dart';

class MobileVerificationProvider extends ChangeNotifier {
  bool _isMobileVerified = false;
  bool get isMobileVerified => _isMobileVerified;
  MobileVerificationService mobileVerService = MobileVerificationService();

  void verifyMobile(
      {required BuildContext context, required String mobileNumber}) async {
    _isMobileVerified = await mobileVerService.verifyMobile(
        context: context, mobileNumber: mobileNumber);
  }
}
