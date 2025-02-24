import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/get_notifications_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class GetNotificationsService {
  Future<GetNotificationsModel?> getNotifications(BuildContext context) async {
    try {
      Response response = await HttpHelper.get(
          context: context, uri: ApiHelper.getNotifications);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          GetNotificationsModel model = GetNotificationsModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting Notifications => $e");
      return null;
    }
  }
}
