import 'package:flutter/material.dart';
import 'package:vaidraj/models/get_branch.dart';
import 'package:vaidraj/services/get_branch_service/get_branch_service.dart';

class GetBrachProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GetBranchService branchService = GetBranchService();

  GetBranch? getBranchModel;

  Future<void> getBranch({required BuildContext context}) async {
    _isLoading = true;
    getBranchModel = await branchService.getBranch(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
