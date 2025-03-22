import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/upcoming_appointment_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class DoctorAppointmentsService {
  Future<UpcomingAppointmentModel?> getDoctorAppointments(
      {required BuildContext context,
      required String branchId,
      required String date,
      required int currentPage,
      required int perPage}) async {
    try {
      Response response = await HttpHelper.get(
          uri: ApiHelper.getDoctorAppointments(
              branchId: branchId,
              date: date,
              currentPage: currentPage,
              perPage: perPage),
          context: context);
      // log(ApiHelper.getDoctorAppointments(
      //     branchId: branchId,
      //     date: date,
      //     currentPage: currentPage,
      //     perPage: perPage));
      // log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          UpcomingAppointmentModel model =
              UpcomingAppointmentModel.fromJson(data);
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
