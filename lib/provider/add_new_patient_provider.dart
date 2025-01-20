import 'package:flutter/material.dart';
import 'package:vaidraj/models/add_new_patient.dart';
import 'package:vaidraj/services/add_new_patient/add_new_patient_service.dart';

class AddNewPatientProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AddNewPatientService service = AddNewPatientService();

  AddPatientModel? patientModel;

  Future<void> addPatient(
      {required BuildContext context,
      required int branchId,
      required String name,
      required String email,
      required String mobile,
      required String password,
      required String address,
      required String birthDate}) async {
    _isLoading = true;
    patientModel = await service.addPatient(
        context: context,
        branchId: branchId,
        name: name,
        email: email,
        mobile: mobile,
        password: password,
        address: address,
        birthDate: birthDate);
    _isLoading = false;
    notifyListeners();
  }
}
