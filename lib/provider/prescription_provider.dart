import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/models/product_model.dart';
import 'package:vaidraj/services/product_service/product_service.dart';

class PrescriptionStateProvider extends ChangeNotifier {
  /// loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// variables
  /// selected disease
  String _selectedDisease = "";
  String get selectedDisease => _selectedDisease;
  set setSelectedDisease(String disease) {
    _selectedDisease = disease;
    // notifyListeners();
  }

  /// selected diseaseId
  int _selectedDiseaseId = 0;
  int get selectedDiseaseId => _selectedDiseaseId;
  set setSelectedDiseaseId(int diseaseId) {
    _selectedDiseaseId = diseaseId;
    // notifyListeners();
  }

  /// init disease on start
  void initSelectedDisease() {
    _selectedDisease = 'Depression';
    _selectedDiseaseId = 16;
    notifyListeners();
  }

  //// get all products
  ProductService productService = ProductService();

  /// model for prescription
  PrescriptionModel _prescriptionModel =
      PrescriptionModel(patientName: "", diseases: []);
  PrescriptionModel get prescriptionModel => _prescriptionModel;
  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;

  Future<void> getAllProducts({required BuildContext context}) async {
    _isLoading = true;
    _productModel = await productService.getAllProduct(context: context);
    print(_productModel?.data?.data?.length);
    _isLoading = false;
    notifyListeners();
  }

  void updateDisease({required String disease, required int diseaseId}) {
    final existingDisease = _prescriptionModel.diseases?.firstWhere(
        (e) => e.diseaseName == disease,
        orElse: () => Diseases(diseaseName: disease, medicine: []));
    if (_prescriptionModel.diseases?.contains(existingDisease) == false) {
      _prescriptionModel.diseases?.add(existingDisease!);
    }
    _selectedDisease = disease;
    _selectedDiseaseId = diseaseId;
    log(_prescriptionModel.toString());
    notifyListeners();
  }

  void updateMedicineSelection(
      {required int productId, required bool isSelected}) {
    final disease = _prescriptionModel.diseases?.firstWhere(
      (e) => e.diseaseName == _selectedDisease,
    );
    if (disease?.medicine != null) {
      final medicine = disease?.medicine?.firstWhere(
        (e) => e.productId == productId,
        orElse: () => Medicine(
            isSelected: false,
            productId: productId,
            time: [],
            toBeTaken: "Before Meal"),
      );
      medicine?.isSelected = isSelected;

      _prescriptionModel.diseases
          ?.firstWhere((e) => e.diseaseName == _selectedDisease)
          .medicine
          ?.add(medicine!);
    }
    log(_prescriptionModel.toString());
    notifyListeners();
  }
}
