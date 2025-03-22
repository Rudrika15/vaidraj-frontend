import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/main.dart';
import 'package:vaidraj/models/mobile_verification_model.dart';
import 'package:vaidraj/provider/profile_provider.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';

class UpdateFcmTokenService {
  Future<bool> updateFCMToken({required BuildContext context}) async {
    try {
      String fcmToken = await SharedPrefs.getFCMToken();
      // print('got this FCM Token => $fcmToken');
      if (fcmToken != "") {
        var body = {'form_token': fcmToken};
        Response response = await HttpHelper.post(
            uri: ApiHelper.updateFCMToken, context: context, body: body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data['success'] == true) {
            VerifyMobileNumberModel profileModel =
                VerifyMobileNumberModel.fromJson(data);
            ProfileProvider profileProvider = context.read<ProfileProvider>();
            profileProvider.setUserModel = profileModel;
            return true;
          }
        }
      } else {
        WidgetHelper.customSnackBar(
            context: context, title: "FCM TOken Not Found", isError: true);
        return false;
      }
      return false;
    } catch (e) {
      print('error while updating FCM Token => $e');
      return false;
    }
  }
}
