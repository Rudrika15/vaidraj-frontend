import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:vaidraj/models/appointment_model.dart';
import 'package:vaidraj/models/todays_appointment_model.dart';
import 'package:vaidraj/models/upcoming_appointment_model.dart';
import 'package:vaidraj/services/appointment/create_new_appointment.dart';
import 'package:vaidraj/services/appointment/doctor_appointments_service.dart';
import 'package:vaidraj/services/appointment/todays_appointment_service.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';

import '../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class AppointmentProvider extends ChangeNotifier {
  // loader
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // service
  AppointmentService service = AppointmentService();
  // appointment models
  AppointmentModel? _appointmentModel;
  AppointmentModel? get appointmentModel => _appointmentModel;

  //----
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String get date => _date;
  String? _branchId;
  String? get branchId => _branchId;

  Future<bool> setBranchId({String? branchId}) async {
    _isLoading = true;
    _branchId = branchId ?? await SharedPrefs.getBranchId();
    if (_branchId == "" || _branchId == null) {
      _isLoading = false;
      _pagingController.refresh();
      notifyListeners();
      // print("branch - => $_branchId");
      return false;
    }
    _isLoading = false;
    _pagingController.refresh();
    notifyListeners();
    // print("branch => $_branchId");
    return true;
  }

  /// choose date which appointment to show
  Future<void> chooseDateAppointments({required BuildContext context}) async {
    DateTime? dob = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month + 1, DateTime.now().day));
    if (dob != null) {
      _date = DateFormat('yyyy-MM-dd').format(dob);
      _doctorAppointment = null;
      _pagingController.refresh();
    }
    notifyListeners();
  }

  ////
  /// model
  UpcomingAppointmentModel? _doctorAppointment;
  UpcomingAppointmentModel? get patientsModel => _doctorAppointment;

  /// service
  DoctorAppointmentsService doctorService = DoctorAppointmentsService();

  ///
  final PagingController<int, UpcomingAppointmentInfo> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, UpcomingAppointmentInfo> get pagingController =>
      _pagingController;
  void initPaginController({
    required BuildContext context,
  }) {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(
        pageKey: pageKey,
        context: context,
      );
    });
  }

  Future<void> fetchPage({
    required int pageKey,
    required BuildContext context,
  }) async {
    try {
      print(pageKey);
      _doctorAppointment = await doctorService.getDoctorAppointments(
          context: context,
          currentPage: pageKey,
          date: date,
          branchId: _branchId ?? "-",
          perPage: 5);
      final isLastPage = ((_doctorAppointment?.data?.data?.length ?? 0) < 5);
      if (isLastPage) {
        _pagingController.appendLastPage(_doctorAppointment?.data?.data
                ?.where((e) => e.user != null)
                .toList() ??
            []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            _doctorAppointment?.data?.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  /// create new appointment
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
    notifyListeners();
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

  // service
  TodaysAppointmentsModel? _todaysAppointmentsModel;
  TodaysAppointmentsModel? get todaysAppointmentModel =>
      _todaysAppointmentsModel;
  TodaysAppointmentService todaysService = TodaysAppointmentService();
  ///// ---- doctor appointments
  void clearTodaysAppointmentModel() {
    _todaysAppointmentsModel = null;
    notifyListeners();
  }

  /// get todays appointments
  Future<void> getTodaysAppointments({required BuildContext context}) async {
    _isLoading = true;
    _todaysAppointmentsModel = null;
    _todaysAppointmentsModel =
        await todaysService.getTodaysAppointments(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
