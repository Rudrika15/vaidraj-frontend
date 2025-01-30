import 'package:flutter/material.dart';
import 'package:vaidraj/models/branch_address_model.dart';
import 'package:vaidraj/models/get_branch.dart';
import 'package:vaidraj/services/get_branch_service/branch_address.dart';
import 'package:vaidraj/services/get_branch_service/get_branch_service.dart';

class GetBrachProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GetBranchService branchService = GetBranchService();
  GetBranchAddressService addressService = GetBranchAddressService();
  BranchAddressModel? _addressModel;
  BranchAddressModel? get addressModel => _addressModel;
  GetBranch? getBranchModel;

  Future<void> getBranch({required BuildContext context}) async {
    _isLoading = true;
    getBranchModel = await branchService.getBranch(context: context);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getBrachAddress({required BuildContext context}) async {
    _isLoading = true;
    _addressModel = await addressService.getBranchAddress(context: context);
    _isLoading = false;
    notifyListeners();
  }

  void resetBranchAddressModel({required BuildContext context}) {
    _addressModel = null;
    getBrachAddress(context: context);
    notifyListeners();
  }
}
