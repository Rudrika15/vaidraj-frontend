import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vaidraj/models/my_patients_model.dart';
import 'package:vaidraj/services/my_patient_service/my_patient_service.dart';

class MyPatientsProvider extends ChangeNotifier {
  /// loader
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// branchId
  String _branchId = "0";
  String get branchId => _branchId;
  set setBranchId(String branchId) {
    _branchId = branchId;
    _pagingController.refresh();
  }

  /// model
  MyPatientsModel? _patientsModel;
  MyPatientsModel? get patientsModel => _patientsModel;

  /// service
  MyPatientService service = MyPatientService();

  ///
  final PagingController<int, PatientsInfo> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, PatientsInfo> get pagingController => _pagingController;
  void initPaginController({required BuildContext context}) {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey: pageKey, context: context, branchId: _branchId ?? "");
    });
  }

  Future<void> fetchPage(
      {required int pageKey,
      required BuildContext context,
      required String branchId}) async {
    try {
      print(pageKey);
      _patientsModel = await service.getPatients(
          context: context,
          currentPage: pageKey,
          branchId: branchId,
          perPage: 5);
      final isLastPage = ((_patientsModel?.data?.data?.length ?? 0) < 5);
      if (isLastPage) {
        _pagingController.appendLastPage(_patientsModel?.data?.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            _patientsModel?.data?.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
