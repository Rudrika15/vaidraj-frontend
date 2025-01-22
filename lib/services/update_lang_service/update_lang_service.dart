import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vaidraj/models/update_lang_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class UpdateLangService {
  Future<UpdateLangModel?> updateCurrentlang(
      {required BuildContext context, required String lang}) async {
    try {
      // var header = {"Content-Type": "application/json"};
      var body = {"lang": lang};
      Response response = await HttpHelper.post(
          context: context, uri: ApiHelper.updateLang, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          UpdateLangModel model = UpdateLangModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while updating lang => $e");
      return null;
    }
  }
}
