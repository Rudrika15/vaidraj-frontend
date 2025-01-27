import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/mobile_verification_model.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class MobileVerificationService {
  Future<VerifyMobileNumberModel?> verifyMobile(
      {required BuildContext context, required String mobileNumber}) async {
    print(mobileNumber);
    try {
      print("baseurl ${ApiHelper.baseUrl}");
      print("mobile ${ApiHelper.mobileNumVerification}");
      Response response = await HttpHelper.post(
          uri: ApiHelper.mobileNumVerification,
          context: context,
          body: {"mobile": mobileNumber});

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          VerifyMobileNumberModel model =
              VerifyMobileNumberModel.fromJson(data);
          SharedPrefs.saveName(model.data?.name ?? "");
          SharedPrefs.saveMobileNumber(model.data?.mobileNo ?? "");
          SharedPrefs.saveBranchId(model.data?.branchId.toString() ?? "");
          SharedPrefs.saveId(model.data?.id.toString() ?? "");
          SharedPrefs.saveAddress(model.data?.address ?? "");
          SharedPrefs.saveEmail(model.data?.email ?? "");
          SharedPrefs.saveFormToken(model.data?.formToken ?? "");
          SharedPrefs.saveDOB(model.data?.dob ?? "");
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error in mobile verification service = > $e");
      return null;
    }
  }

  Future<bool> verifyPassword(
      {required BuildContext context,
      required String mobile,
      required String password}) async {
    try {
      var passwordObject = {"mobile": mobile, "password": password};
      var header = {"Content-Type": "application/json"};
      Response response = await HttpHelper.post(
          uri: ApiHelper.verifyPassword,
          context: context,
          body: jsonEncode(passwordObject),
          headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          SharedPrefs.saveToken(data['token']);
          print("saving token for staff => ${data['token']}");
          SharedPrefs.saveRole(data['data']["role"]);
          print("saving role for staff => ${data['data']["role"]}");
          return true;
        }
      }
      return false;
    } catch (e) {
      print("error while verifyPassword => $e");
      return false;
    }
  }
}
