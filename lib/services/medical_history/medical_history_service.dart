import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/patient_medical_history_adminside.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class MedicalHistoryService {
  Future<PatientWiseMedicalHistoryModel?> getMedicalHistory({
    required BuildContext context,
  }) async {
    try {
      Response response = await HttpHelper.get(
          context: context, uri: ApiHelper.getMedicalHistory);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          PatientWiseMedicalHistoryModel model =
              PatientWiseMedicalHistoryModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting medical history => $e");
      return null;
    }
  }

  Future<PatientWiseMedicalHistoryModel?> getPatientWiseMedicalHistory(
      {required BuildContext context, required String number}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getPatientWiseMedicalHistory(
            mobileNumber: number,
          ));
      log(ApiHelper.getMedicalHistoryById(
        id: number,
      ));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          PatientWiseMedicalHistoryModel model =
              PatientWiseMedicalHistoryModel.fromJson(data);
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
