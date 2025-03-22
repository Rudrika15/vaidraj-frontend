import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/todays_appointment_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class TodaysAppointmentService {
  Future<TodaysAppointmentsModel?> getTodaysAppointments({
    required BuildContext context,
  }) async {
    try {
      Response response = await HttpHelper.get(
          uri: ApiHelper.todaysAppointment, context: context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          TodaysAppointmentsModel model =
              TodaysAppointmentsModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      // print("error while getting Todays appointment => $e");
      return null;
    }
  }
}
