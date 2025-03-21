import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/models/patient_medical_history_adminside.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';

class MedicalHistoryProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // late PagingController<int, Appointments> pagingController;
  // MedicalHistoryProvider() {
  //   pagingController = PagingController(firstPageKey: 1);
  // }
  // static const _pageSize = 5;

  MedicalHistoryService service = MedicalHistoryService();
  PatientWiseMedicalHistoryModel? _medicalHistoryModel;
  PatientWiseMedicalHistoryModel? get medicalHistoryModel =>
      _medicalHistoryModel;
  // Future<void> fetchPage(
  //     {required int pageKey, required BuildContext context}) async {
  //   try {
  //     MedicalHistoryListModel? newItems = await getMedicalHistory(
  //       context: context,
  //       currentPage: pageKey,
  //     );
  //     final isLastPage =
  //         ((newItems?.data?.data?.appointments?.length ?? 0) < _pageSize);
  //     if (isLastPage) {
  //       pagingController
  //           .appendLastPage(newItems?.data?.data?.appointments ?? []);
  //     } else {
  //       final nextPageKey = pageKey + 1;

  //       pagingController.appendPage(
  //           newItems?.data?.data?.appointments ?? [], nextPageKey);
  //     }
  //   } catch (error) {
  //     pagingController.error = error;
  //   }
  // }

  Future<PatientWiseMedicalHistoryModel?> getMedicalHistory({
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    _medicalHistoryModel = null;
    _medicalHistoryModel = await service.getMedicalHistory(
      context: context,
    );
    if (_medicalHistoryModel?.success == false) {
      return null;
    }
    _isLoading = false;
    notifyListeners();

    return _medicalHistoryModel;
  }

  void resetState({required BuildContext context}) {
    _isLoading = false; // Reset loading flag
    _medicalHistoryModel = null; // Clear disease model
    // pagingController.dispose();
    // pagingController = PagingController(firstPageKey: 1);
    // pagingController.addPageRequestListener((pageKey) {
    //   fetchPage(pageKey: pageKey, context: context);
    // });
    notifyListeners(); // Notify listeners of changes
  }
}
