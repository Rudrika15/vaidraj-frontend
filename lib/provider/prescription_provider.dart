import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/services/prescription_service/prescription_service.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';

import '../models/product_model.dart';

class PrescriptionStateProvider extends ChangeNotifier {
  /// loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// prescription service
  PrescriptionService service = PrescriptionService();

  /// variables
  /// selected disease
  String _selectedDisease = "";
  String get selectedDisease => _selectedDisease;
  set setSelectedDisease(String disease) {
    _selectedDisease = disease;
    notifyListeners();
  }

  /// selected diseaseId
  int _selectedDiseaseId = 0;
  int get selectedDiseaseId => _selectedDiseaseId;
  set setSelectedDiseaseId(int diseaseId) {
    _selectedDiseaseId = diseaseId;
    // notifyListeners();
  }

  /// init disease on start
  Future<void> initSelectedDisease(
      {required int diseaseId, required String disease}) async {
    _isLoading = true;
    _selectedDiseaseId = diseaseId;
    _selectedDisease = disease;
    _isLoading = false;
    notifyListeners();
  }

  //// get all products
  ProductService productService = ProductService();

  /// model for prescription
  PrescriptionModel _prescriptionModel =
      PrescriptionModel(patientName: "", diseases: []);
  PrescriptionModel get prescriptionModel => _prescriptionModel;
  List<Diseases> _diseaseList = [];
  List<Diseases> get diseaseList => _diseaseList;
  void emptyDiseaseListAfterSuccess() {
    _diseaseList.clear();
    updateDisease(disease: _selectedDisease, diseaseId: _selectedDiseaseId);
    notifyListeners();
  }

  ///// products model
  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;
  List<Product> _productToShow = [];
  List<Product> get productToShow => _productToShow;

  Future<void> getAllProducts({required BuildContext context}) async {
    _isLoading = true;
    _productModel = await productService.getAllProduct(context: context);
    if (_productModel != null) {
      _productModel?.data?.data?.forEach((e) {
        e.diseaseProducts?.forEach((d) {
          if (d.diseases?.diseaseName == _selectedDisease) {
            _productToShow.add(e);
          }
        });
      });
    }
    _isLoading = false;
    notifyListeners();
  }

  void updateDisease({required String disease, required int diseaseId}) {
    /// check if diseases exist in list or not
    final existingDisease = diseaseList.firstWhereOrNull(
      (e) => e.diseaseName == disease,
    );
    if (existingDisease == null) {
      _diseaseList.add(Diseases(diseaseName: disease, medicine: []));
    }
    log(productToShow.map((e) => print(e)).toString());
    // update both fields
    _selectedDisease = disease;
    _selectedDiseaseId = diseaseId;
    _productToShow.clear();
    List<Product> newList = [];

    /// loop and generate new disease wise list
    _productModel?.data?.data?.forEach((e) {
      if (e.diseaseId == _selectedDiseaseId) {
        newList.add(e);
      }
    });
    print(
        'products that can be added in this $_selectedDisease is ${newList.length}');

    /// attach new list to original list
    if (newList.isNotEmpty) {
      _productToShow = newList;
    } else {
      _diseaseList.removeWhere((e) => e.diseaseName == _selectedDisease);
      print("add no thi yu");
    }

    log(newList.length.toString());
    log(_diseaseList.map((e) => print(e)).toString());
    notifyListeners();
  }

  void updateMedicineSelection(
      {required int productId, required bool isSelected}) {
    // Find the disease that matches the selected disease name
    final diseaseIndex =
        _diseaseList.indexWhere((e) => e.diseaseName == _selectedDisease);

    // If disease is found
    if (diseaseIndex != -1) {
      final disease = _diseaseList[diseaseIndex];

      // If the disease has a medicine list, proceed
      if (disease.medicine != null) {
        // Check if the medicine with the given productId already exists
        final existingMedicine = disease.medicine?.firstWhereOrNull(
          (e) => e.productId == productId,
        );

        if (existingMedicine != null) {
          // If medicine is found, update its selection status
          existingMedicine.isSelected = isSelected;
        } else {
          // If medicine doesn't exist, create and add it
          disease.medicine?.add(Medicine(
            productId: productId,
            isSelected: isSelected,
            time: [],
            toBeTaken: "before",
          ));
        }

        // After the update, ensure the disease is updated in the list
        _diseaseList[diseaseIndex] = disease; // Update the reference of disease
      }
    } else {
      updateDisease(disease: _selectedDisease, diseaseId: _selectedDiseaseId);
    }

    // Log the updated disease list for debugging
    log(_diseaseList.toString());

    // Notify listeners to update the UI
    notifyListeners();
  }

  void updateMedicineTime({
    required int productId,
    required String dayTime,
  }) {
    // Find the index of the disease with the selected disease name
    final diseaseIndex =
        _diseaseList.indexWhere((e) => e.diseaseName == _selectedDisease);

    // If the disease is found
    if (diseaseIndex != -1) {
      final disease = _diseaseList[diseaseIndex];

      // Find the medicine with the given productId within the disease's medicine list
      final medicine = disease.medicine?.firstWhereOrNull(
        (e) => e.productId == productId,
      );

      if (medicine != null) {
        // If add is true, add the dayTime to the medicine's time list if it's not already present

        if (medicine.time?.contains(dayTime) == false) {
          medicine.time?.add(dayTime);
        } else {
          medicine.time?.remove(dayTime);
        }

        // After modifying, update the disease object in the list
        _diseaseList[diseaseIndex] = disease;

        // Log the updated list for debugging
        log(_diseaseList.toString());
      }
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  /// Method to send the diseases list as a JSON string to the backend
  Future<bool> sendDataToBackend(
      {required int appointmentId,
      required BuildContext context,
      required String patientName,
      required String note,
      required String otherNote}) async {
    _isLoading = true;
    if (_diseaseList.any((e) =>
        e.medicine?.isEmpty == true ||
        e.medicine?.every((f) => f.isSelected == false) == true ||
        e.medicine?.any(
                (f) => f.isSelected == true && (f.time?.isEmpty ?? true)) ==
            true)) {
      // Show error message if no medicine is selected or if selected medicines don't have time set
      WidgetHelper.customSnackBar(
          context: context,
          title: "No Medicine Selected or Time Missing",
          isError: true);
      _isLoading = false;
      notifyListeners();
      return false;
    }
    WidgetHelper.customSnackBar(
      context: context,
      title: "Sending Data",
    );
    _isLoading = false;
    notifyListeners();
    bool success = await service.createPrescription(
        context: context,
        patientName: patientName,
        note: note,
        otherNote: otherNote,
        appointmentId: appointmentId,
        diseaseList: diseaseList);
    _isLoading = false;
    return success;
  }
}
