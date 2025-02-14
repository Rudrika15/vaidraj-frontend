import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../models/my_patients_model.dart';
import '../services/my_patient_service/my_patient_service.dart';

class MyPatientsProvider extends ChangeNotifier {
  /// loader
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// branchId
  String _branchId = "";
  String get branchId => _branchId;
  void initBranchId() async {
    _branchId = await SharedPrefs.getBranchId();
    notifyListeners();
  }

  set setBranchId(String branchId) {
    _branchId = branchId;
    pagingController.refresh();
  }

  /// searchQuery
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  set setSearchQuery(String query) {
    _searchQuery = query;
    pagingController.refresh(); // Refresh paging when search query changes
    notifyListeners(); // Notify listeners to rebuild UI
  }

  /// model
  MyPatientsModel? _patientsModel;
  MyPatientsModel? get patientsModel => _patientsModel;

  /// service
  MyPatientService service = MyPatientService();

  /// Paging controller
  final PagingController<int, PatientsInfo> pagingController =
      PagingController(firstPageKey: 1);
  // PagingController<int, PatientsInfo> get pagingController => _pagingController;

  void initPaginController({required BuildContext context}) {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(
          pageKey: pageKey,
          context: context,
          branchId: _branchId == "" ? null : _branchId);
    });
  }

  Future<void> fetchPage({
    required int pageKey,
    required BuildContext context,
    String? branchId,
  }) async {
    try {
      // Fetch the list of patients from the service
      _patientsModel = await service.getPatients(
        context: context,
        currentPage: pageKey,
        branchId: branchId,
        perPage: 8,
      );

      final patients = _patientsModel?.data?.data ?? [];
      final isLastPage = patients.length < 8;

      List<PatientsInfo> dataToAppend;

      // If search query exists, filter patients
      if (_searchQuery.isNotEmpty) {
        dataToAppend = filterPatients(patients);
      } else {
        dataToAppend = patients;
      }

      // Append data based on whether it is the last page
      if (isLastPage) {
        pagingController.appendLastPage(dataToAppend);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(dataToAppend, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  /// Function to filter the patients based on the search query
  List<PatientsInfo> filterPatients(List<PatientsInfo> patients) {
    return patients.where((patient) {
      // Filter logic: Check if search query matches any field (e.g., patient's name)
      return patient.appointment?.name
              ?.toLowerCase()
              .contains(_searchQuery.toLowerCase()) ??
          false;
    }).toList();
  }

  /// Every time the user types, the previous timer is canceled and a new timer is started. If the user stops typing for 500ms, the timer triggers and updates the search query.
  Timer? _debounceTimer;
  Timer? get debounceTimer => _debounceTimer;
  void onSearchChanged({required String query}) {
    // Cancel the previous timer if any
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    // Set up a new timer to wait for user to stop typing
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // This will be executed after the debounce delay

      _searchQuery = query; // Update the search query
      print(_searchQuery);
    });
  }
}
