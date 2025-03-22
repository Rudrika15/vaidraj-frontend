import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/services/prescription_service/prescription_service.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import '../models/product_model.dart';
import '../models/upcoming_appointment_model.dart';

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

  /// empty disease list
  void emptyDiseaseListAfterSuccess() {
    _diseaseList.clear();
    // updateDisease(disease: _selectedDisease, diseaseId: _selectedDiseaseId);
    notifyListeners();
  }

  Future<void> initPreviousDiseaseList(
      {required List<Medicines> previousList}) async {
    _isLoading = true;
    // print("Starting to initialize previous disease list...");
    List<Medicine> tempList = List.generate(
        previousList.length,
        (i) => Medicine(
            isSelected: true,
            productId: int.parse(previousList[i].productId ?? ""),
            time: previousList[i].time?.split(","),
            toBeTaken: previousList[i].toBeTaken));
    if (tempList.isNotEmpty) {
      // tempList.map((i) => print("i ====> ${i.productId}"));
    }
    for (Medicine m in tempList) {
      // print("Processing medicine: ${m.productId}");

      final index = _productToShow.indexWhere((i) => i.id == m.productId);

      if (index != -1) {
        final disease = _diseaseList[index];
        // print("Disease found at index $index: ${disease.toString()}");

        // Find the medicine by productId
        final medicineIndex =
            disease.medicine?.indexWhere((mm) => m.productId == mm.productId);

        // If both the disease and medicine are found
        if (medicineIndex != null && medicineIndex != -1) {
          final medicine = disease.medicine?[medicineIndex];
          // print("Found medicine: ${medicine.toString()}");

          disease.medicine?[medicineIndex] = medicine!;
          _diseaseList[index] = disease;

          // print("Updated medicine: ${medicine.toString()}");
          // print("Updated disease: ${disease.toString()}");
        } else {
          // print("No medicine found for productId ${m.productId}");
        }
      } else {
        // print("No disease found for medicine with productId ${m.productId}");
      }
    }

    _isLoading = false;
    // print("Finished initializing disease list");
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
    // if (_productModel != null) {
    //   _productModel?.data?.data?.forEach((e) {
    //     e.diseaseProducts?.forEach((d) {
    //       if (d.diseases?.id == _selectedDiseaseId) {
    _productToShow.addAll(_productModel?.data?.data ?? []);
    //       }
    //     });
    //   });
    // }
    _isLoading = false;
    notifyListeners();
  }

  void updateDisease({
    required String disease,
    required int diseaseId,
    List<Medicines>? previousList,
  }) {
    // Check if disease already exists, if not, add it
    final existingDisease = diseaseList.firstWhereOrNull(
      (e) => e.diseaseName == disease,
    );
    if (existingDisease == null) {
      _diseaseList.add(Diseases(diseaseName: disease, medicine: []));
    }

    _selectedDisease = disease;
    _selectedDiseaseId = diseaseId;
    _productToShow.clear();

    // Filter products by disease ID
    List<Product> newList = [];
    _productModel?.data?.data?.forEach((e) {
      if (e.diseaseProducts?.any((d) => d.diseaseId == _selectedDiseaseId) ??
          false) {
        newList.add(e);
      }
    });

    // print('Products that can be added to $_selectedDisease: ${newList.length}');

    /// if found products than add them in list
    if (newList.isNotEmpty) {
      _productToShow = newList;
      //// if previous list found than try to load them in medicine list to let doctor know that this is the medicines that are previusly selected
      if (previousList != null && previousList.isNotEmpty) {
        final tempList = previousList
            .map((prevMed) => Medicine(
                  isSelected: true,
                  productId: int.tryParse(prevMed.productId ?? "") ?? -1,
                  time: prevMed.time?.split(","),
                  toBeTaken: prevMed.toBeTaken,
                ))
            .where((med) => med.productId != -1)
            .toList();

        final diseaseIndex =
            diseaseList.indexWhere((e) => e.diseaseName == selectedDisease);

        if (diseaseIndex != -1) {
          final currentMedicines = _diseaseList[diseaseIndex].medicine ?? [];
          //// do check and add them
          for (var medicine in tempList) {
            if (_productToShow.any((prod) => prod.id == medicine.productId) &&
                !currentMedicines
                    .any((med) => med.productId == medicine.productId)) {
              currentMedicines.add(medicine);
            }
          }

          /// add them in original list
          _diseaseList[diseaseIndex].medicine = currentMedicines;
          // log(_diseaseList.toString());
        }
      }
    } else {
      diseaseList.removeWhere((e) => e.diseaseName == _selectedDisease);
      // print("No products found.");
    }

    // log(newList.length.toString());
    // log(_diseaseList.map((e) => e.toString()).toList().toString());

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
    // log(_diseaseList.toString());

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
        // log(_diseaseList.toString());
      }
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  /// Method to send the diseases list as a JSON string to the backend
  Future<bool> sendDataToBackend(
      {required int appointmentId,
      required int pId,
      required BuildContext context,
      required String patientName,
      required String note,
      required bool isCreating,
      required String otherNote}) async {
    _isLoading = true;
    // log(_diseaseList.toString());
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
        isCreating: isCreating,
        pId: pId,
        otherNote: otherNote,
        appointmentId: appointmentId,
        diseaseList: diseaseList);
    _isLoading = false;
    return success;
  }
}
