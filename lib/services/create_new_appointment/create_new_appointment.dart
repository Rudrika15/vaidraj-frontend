import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/appointment_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class AppointmentService {
  Future<AppointmentModel?> createAppointment({
    required BuildContext context,
    required int diseaseId,
    required String appointmentDate,
    required String slot,
    required String subject,
    required String message,
    required String name,
    required String email,
    required String address,
    required String dob,
    required String contactNumber,
    required int userId,
  }) async {
    try {
      var body = {
        "disease_id": diseaseId.toString(),
        "date": appointmentDate,
        "slot": slot,
        "subject": subject,
        "message": message,
        "user_id": userId.toString(),
        "name": name,
        "email": email,
        "address": address,
        'dob': dob,
        "contact": contactNumber
      };
      Response response = await HttpHelper.post(
          uri: ApiHelper.createAppointment, context: context, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          AppointmentModel model = AppointmentModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while creating appointment => $e");
      return null;
    }
  }
}
