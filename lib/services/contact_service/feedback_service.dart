import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class FeedbackService {
  Future<bool> feedback(
      {required BuildContext context,
      String? rating,
      String? title,
      String? description}) async {
    try {
      var body = {"rating": rating, "title": title, "description": description};
      Response response = await HttpHelper.post(
          uri: ApiHelper.feedback, context: context, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // print("error while giving feedback => $e");
      return false;
    }
  }
}
