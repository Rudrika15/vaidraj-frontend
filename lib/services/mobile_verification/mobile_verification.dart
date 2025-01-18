import 'package:flutter/material.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class MobileVerificationService {
  Future<bool> verifyMobile(
      {required BuildContext context, required String mobileNumber}) async {
    print(mobileNumber);
    try {
      print("baseurl ${ApiHelper.baseUrl}");
      print("mobile ${ApiHelper.mobileNumVerification}");
      Response response = await HttpHelper.post(
          uri: ApiHelper.mobileNumVerification,
          context: context,
          body: {"mobile": mobileNumber});

      if (response.statusCode == 200 || response.statusCode == 201) {}
      return false;
    } catch (e) {
      print("error in mobile verification service = > $e");
      return false;
    }
  }
}
