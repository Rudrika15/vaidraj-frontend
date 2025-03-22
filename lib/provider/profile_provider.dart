import 'package:flutter/material.dart';

import '../models/mobile_verification_model.dart';

class ProfileProvider extends ChangeNotifier {
  /// will init user profile data to be used dynamically anywhere
  VerifyMobileNumberModel _userModel = VerifyMobileNumberModel();
  VerifyMobileNumberModel get userModel => _userModel;
  set setUserModel(VerifyMobileNumberModel model) {
    _userModel = model;
    notifyListeners();
  }

  void setUserInfo(
      {String? name,
      String? address,
      String? dob,
      String? email,
      int? branchId,
      String? language,
      String? mobileNo,
      int? userId,
      String? role}) {
    _userModel.data?.name = name;
    _userModel.data?.address = address;
    _userModel.data?.branchId = branchId;
    _userModel.data?.dob = dob;
    _userModel.data?.email = email;
    _userModel.data?.id = userId;
    _userModel.data?.language = language;
    _userModel.data?.mobileNo = mobileNo;
    _userModel.data?.role = role;
    notifyListeners();
  }
}
