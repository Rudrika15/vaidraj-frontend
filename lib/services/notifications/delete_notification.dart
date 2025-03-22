import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/delete_notification_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class DeleteNotificationsService {
  Future<DeleteNotificationModel?> deleteNotifications(
      {required BuildContext context, required String id}) async {
    try {
      Response response = await HttpHelper.post(
          context: context, uri: ApiHelper.deleteNotifications(id: id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          DeleteNotificationModel model =
              DeleteNotificationModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      // print("error while getting Notifications => $e");
      return null;
    }
  }
}
