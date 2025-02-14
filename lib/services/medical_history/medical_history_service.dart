import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/models/patient_medical_history_adminside.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class MedicalHistoryService {
  Future<MedicalHistoryListModel?> getMedicalHistory(
      {required BuildContext context, required int currentPage}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getMedicalHistory(
              currentPage: currentPage, perPage: 1));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          MedicalHistoryListModel model =
              MedicalHistoryListModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting medical history => $e");
      return null;
    }
  }

  Future<PatientMedicalHistoryModel?> getMedicalHistoryById(
      {required BuildContext context, required String id}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getMedicalHistoryById(
            id: id.toString(),
          ));
      log(ApiHelper.getMedicalHistoryById(
        id: id.toString(),
      ));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          PatientMedicalHistoryModel model =
              PatientMedicalHistoryModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting medical history by Id => $e");
      return null;
    }
  }
}
