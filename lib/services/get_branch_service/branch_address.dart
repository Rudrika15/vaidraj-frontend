import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';
import '../../models/branch_address_model.dart';

class GetBranchAddressService {
  Future<BranchAddressModel?> getBranchAddress(
      {required BuildContext context}) async {
    try {
      Response response = await HttpHelper.get(
          context: context, uri: ApiHelper.getBranchAddress);
      // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data["success"] == true) {
          BranchAddressModel branches = BranchAddressModel.fromJson(data);
          print(branches.success);
          return branches;
        }
      }
      return null;
    } catch (e) {
      print("error while getting branch Address=> $e");
      return null;
    }
  }
}
