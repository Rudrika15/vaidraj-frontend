import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:provider/provider.dart';
import 'package:vaidraj/models/update_user_profile_model.dart';
import 'package:vaidraj/provider/profile_provider.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class UpdateUserProfileService {
  Future<UpdateProfileModel?> updateUserProfile(
      {required BuildContext context,
      required String name,
      required String branchId,
      required String address,
      required String dob,
      required String email}) async {
    try {
      var body = {
        "name": name,
        "branch_id": branchId,
        "address": address,
        "dob": dob,
        "email": email
      };
      Response response = await HttpHelper.post(
          context: context, uri: ApiHelper.updateProfile, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          UpdateProfileModel model = UpdateProfileModel.fromJson(data);
          //// store the updated data
          SharedPrefs.saveRole(model.data?.role ?? "");
          SharedPrefs.saveName(model.data?.name ?? "");
          SharedPrefs.saveMobileNumber(model.data?.mobileNo ?? "");
          SharedPrefs.saveBranchId(model.data?.branchId.toString() ?? "");
          SharedPrefs.saveId(model.data?.id.toString() ?? "");
          SharedPrefs.saveAddress(model.data?.address ?? "");
          SharedPrefs.saveEmail(model.data?.email ?? "");
          SharedPrefs.saveDOB(model.data?.dob ?? "");
          ProfileProvider profileProvider = context.read<ProfileProvider>();
          profileProvider.setUserInfo(
              address: model.data?.address ?? "",
              dob: model.data?.dob ?? "",
              email: model.data?.email ?? "",
              branchId: int.parse((model.data?.branchId ?? "")),
              userId: model.data?.id ?? 0,
              language: model.data?.language ?? "",
              mobileNo: model.data?.mobileNo ?? "",
              name: model.data?.name ?? "",
              role: model.data?.role ?? "");
          return model;
        }
      }
      return null;
    } catch (e) {
      // print("error while updating user => $e");
      return null;
    }
  }
}
