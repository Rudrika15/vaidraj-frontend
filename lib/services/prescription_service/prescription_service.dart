import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class PrescriptionService {
  Future<bool> createPrescription({
    required BuildContext context,
    required String patientName,
    String? note,
    String? otherNote,
    required bool isCreating,
    required int appointmentId,
    required int pId,
    required List<Diseases> diseaseList,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      Map<String, dynamic> payload =
          _buildPayload(diseaseList, note, otherNote, appointmentId);

      Response response;
      if (isCreating) {
        response = await _sendRequest(
          context: context,
          url: ApiHelper.createPrescription,
          payload: payload,
          header: header,
        );
      } else {
        response = await _sendRequest(
          context: context,
          url: ApiHelper.updatePrescription(pId: pId),
          payload: payload,
          header: header,
        );
      }

      return _handleResponse(context, response);
    } catch (e) {
      // print("Error while creating  or updating prescription => $e");
      return false;
    }
  }

  Map<String, dynamic> _buildPayload(
    List<Diseases> diseaseList,
    String? note,
    String? otherNote,
    int appointmentId,
  ) {
    return {
      'appointment_id': appointmentId,
      'note': note,
      'other_medicines': otherNote,
      'medicine': diseaseList
          .map((disease) =>
              disease.medicine?.where((m) => m.isSelected == true).toList())
          .where((medicineList) => medicineList?.isNotEmpty == true)
          .expand((medicineList) => medicineList!)
          .toList(),
    };
  }

  Future<Response> _sendRequest({
    required BuildContext context,
    required String url,
    required Map<String, dynamic> payload,
    required Map<String, String> header,
  }) async {
    // log(url);
    // log(jsonEncode(payload));
    return await HttpHelper.post(
      context: context,
      uri: url,
      body: jsonEncode(payload),
      headers: header,
    );
  }

  bool _handleResponse(BuildContext context, Response response) {
    // log(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success'] == true) {
        WidgetHelper.customSnackBar(context: context, title: data['message']);
        return true;
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: data['message'],
          isError: true,
        );
      }
    }
    return false;
  }

  Future<bool> deletePrescription(
      {required BuildContext context, required int prescriptionId}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.deletePrescription(prescriptionId: prescriptionId));
      // log(ApiHelper.deletePrescription(prescriptionId: prescriptionId));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // print('error while deleting prescriptionId $prescriptionId error => $e');
      return false;
    }
  }
}
