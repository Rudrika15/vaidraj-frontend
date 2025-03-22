import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/delete_account_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class DeleteUserService {
  Future<DeleteAccoutModel?> deleteUser(BuildContext context) async {
    try {
      Response response =
          await HttpHelper.post(context: context, uri: ApiHelper.deleteUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          DeleteAccoutModel model = DeleteAccoutModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      // print("error while deleting account => $e");
      return null;
    }
  }
}
