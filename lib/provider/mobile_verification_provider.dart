import 'package:flutter/material.dart';
import 'package:vaidraj/models/mobile_verification_model.dart';
import 'package:vaidraj/services/mobile_verification/mobile_verification.dart';

class MobileVerificationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isPasswordVerified = false;
  bool get isPasswordVerified => _isPasswordVerified;
  MobileVerificationService mobileVerService = MobileVerificationService();
  VerifyMobileNumberModel? verifyMobileNumberModel;

  Future<void> verifyMobile(
      {required BuildContext context, required String mobileNumber}) async {
    _isLoading = true;
    verifyMobileNumberModel = await mobileVerService.verifyMobile(
        context: context, mobileNumber: mobileNumber);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyPassword(
      {required BuildContext context,
      required String mobile,
      required String password}) async {
    _isLoading = true;
    _isPasswordVerified = await mobileVerService.verifyPassword(
        context: context, mobile: mobile, password: password);
    _isLoading = false;
    notifyListeners();
  }
}
