import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class PrescriptionService {
  Future<bool> createPrescription(
      {required BuildContext context,
      required String patientName,
      String? note,
      String? otherNote,
      required int appointmentId,
      required List<Diseases> diseaseList}) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      Map<String, dynamic> payload = {
        'appointment_id': appointmentId,
        "other_medicines": otherNote,
        'note': note,
        'medicine': diseaseList
            .map((disease) {
              if (disease.medicine?.isNotEmpty == true) {
                // Return selected medicines in each disease
                return disease.medicine
                    ?.where((m) => m.isSelected == true)
                    .toList();
              }
              return null; // Return null if no medicines are selected
            })
            .where((medicineList) =>
                medicineList != null &&
                medicineList.isNotEmpty) // Filter out null and empty lists
            .expand((medicineList) =>
                medicineList!) // Flatten the list of lists into a single list
            .toList(),
      };

      Response response = await HttpHelper.post(
          context: context,
          uri: ApiHelper.createPrescription,
          body: jsonEncode(payload),
          headers: header);
      log(jsonEncode(payload));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          WidgetHelper.customSnackBar(context: context, title: data['message']);
          return true;
        } else {
          WidgetHelper.customSnackBar(
              context: context, title: data['message'], isError: true);
        }
      }
      return false;
    } catch (e) {
      print("error while creating Prescription=> $e");
      return false;
    }
  }
}
