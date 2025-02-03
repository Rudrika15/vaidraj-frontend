import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/services/product_service/product_service.dart';

import '../models/product_model.dart';

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
  List<Diseases> _diseaseList = [];
  List<Diseases> get diseaseList => _diseaseList;
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
    notifyListeners();

    /// attach new list to original list
    _productToShow = newList;
    log(_diseaseList.map((e) => print(e)).toString());
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
            toBeTaken: "Before Meal",
          ));
        }

        // After the update, ensure the disease is updated in the list
        _diseaseList[diseaseIndex] = disease; // Update the reference of disease
      }
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
}
