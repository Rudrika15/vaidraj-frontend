import 'package:flutter/material.dart';
import 'package:vaidraj/models/appointment_model.dart';
import 'package:vaidraj/services/appointment/create_new_appointment.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';

class AppointmentProvider extends ChangeNotifier {
  // loader
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // service
  AppointmentService service = AppointmentService();
  //
  AppointmentModel? _appointmentModel;
  AppointmentModel? get appointmentModel => _appointmentModel;

  Future<bool> createAppointment({
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
    _isLoading = true;

    _appointmentModel = await service.createAppointment(
        context: context,
        diseaseId: diseaseId,
        appointmentDate: appointmentDate,
        slot: slot,
        subject: subject,
        message: message,
        name: name,
        email: email,
        address: address,
        dob: dob,
        contactNumber: contactNumber,
        userId: userId);
    _isLoading = false;
    notifyListeners();
    if (_appointmentModel?.success == true) {
      WidgetHelper.customSnackBar(
          context: context, title: _appointmentModel?.message ?? '');
      return true;
    } else {
      return false;
    }
  }
}
