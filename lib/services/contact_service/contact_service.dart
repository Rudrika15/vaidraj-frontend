import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class ContactService {
  Future<bool> ContactVaidraj(
      {required BuildContext context,
      required String firstName,
      required String lastName,
      required String email,
      required String mobile,
      required String subject,
      required String message}) async {
    try {
      var body = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "subject": subject,
        "message": message
      };
      Response response = await HttpHelper.post(
          uri: ApiHelper.contact, context: context, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('error while contact to vaidraj => $e');
      return false;
    }
  }
}
