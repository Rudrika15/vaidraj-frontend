import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/add_new_patient.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class AddNewPatientService {
  Future<AddPatientModel?> addPatient(
      {required BuildContext context,
      required int branchId,
      required String name,
      required String email,
      required String mobile,
      required String password,
      required String address,
      required String birthDate}) async {
    try {
      var patientObject = {
        "branch_id": branchId,
        "name": name,
        "email": email,
        "mobile": mobile,
        "password": password,
        "address": address,
        "birth_date": birthDate
      };
      var header = {"Content-Type": "application/json"};
      print(jsonEncode(patientObject));
      Response response = await HttpHelper.post(
          uri: ApiHelper.newPatient,
          context: context,
          body: jsonEncode(patientObject),
          headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          AddPatientModel model = AddPatientModel.fromJson(data);
          SharedPrefs.saveToken(model.token ?? "");
          SharedPrefs.saveRole("patient");
          SharedPrefs.saveName(model.data?.name ?? "");
          SharedPrefs.saveMobileNumber(model.data?.mobileNo ?? "");
          SharedPrefs.saveBranchId(model.data?.branchId.toString() ?? "");
          SharedPrefs.saveId(model.data?.id.toString() ?? "");
          SharedPrefs.saveAddress(model.data?.address ?? "");
          SharedPrefs.saveEmail(model.data?.email ?? "");
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while adding new patient => $e");
      return null;
    }
  }
}
