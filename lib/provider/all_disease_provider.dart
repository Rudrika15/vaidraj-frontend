import 'package:flutter/material.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/services/all_disease_service/all_disease_service.dart';

class AllDiseaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // static const _pageSize = 5;
  // final PagingController<int, Diseases> pagingController =
  //     PagingController(firstPageKey: 1);
  // AllDieseasesModel? _diseaseModel;
  // AllDieseasesModel? get diseasesModel => _diseaseModel;
  AllDieseasesModel? _dieseasesModelForAppointment;
  AllDieseasesModel? get diseasesModelForAppointment =>
      _dieseasesModelForAppointment;
  AllDiseaseService service = AllDiseaseService();
  // Future<void> fetchPage(
  //     {required int pageKey, required BuildContext context}) async {
  //   try {
  //     print(pageKey);
  //     AllDieseasesModel? newItems = await getAllDisease(
  //       context: context,
  //       currentPage: pageKey,
  //     );
  //     final isLastPage = ((newItems?.data?.data?.length ?? 0) < _pageSize);
  //     if (isLastPage) {
  //       pagingController.appendLastPage(newItems?.data?.data ?? []);
  //     } else {
  //       final nextPageKey = pageKey + 1;
  //       pagingController.appendPage(newItems?.data?.data ?? [], nextPageKey);
  //     }
  //   } catch (error) {
  //     pagingController.error = error;
  //   }
  // }

  /// this will get all diseases with artical,video,products with pagination
  // Future<AllDieseasesModel?> getAllDisease(
  //     {required BuildContext context, required int currentPage}) async {
  //   _isLoading = true;
  //   _diseaseModel = await service.getDieases(
  //     context: context,
  //     currentPage: currentPage,
  //   );
  //   _isLoading = false;
  //   notifyListeners();
  //   return _diseaseModel;
  // }

  Future<void> getAllDiseaseWithoutPagination(
      {required BuildContext context}) async {
    _isLoading = true;
    _dieseasesModelForAppointment =
        await service.getDieasesWithoutPaginiation(context: context);
    _isLoading = false;
    notifyListeners();
  }

  // Future<void> setModelNull() async {
  //   _diseaseModel = null;
  //   pagingController.error = null;
  //   pagingController.refresh();
  //   notifyListeners();
  // }

  // Method to empty or reset the provider state
  void resetState({required BuildContext context}) {
    _isLoading = false; // Reset loading flag
    // _diseaseModel = null; // Clear disease model
    _dieseasesModelForAppointment = null; // Clear appointment model
    // pagingController
    //     .refresh(); // Reset the paging controller // Clear the pages
    // pagingController.error = null;
    getAllDiseaseWithoutPagination(context: context); // Clear any error state
    notifyListeners(); // Notify listeners of changes
  }
}
