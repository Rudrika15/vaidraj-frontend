import 'package:flutter/material.dart';
import 'package:vaidraj/models/delete_account_model.dart';
import 'package:vaidraj/services/delete_user_service/delete_user_service.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';

class DeleteUserProvider extends ChangeNotifier with NavigateHelper {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DeleteUserService deleteUserService = DeleteUserService();
  DeleteAccoutModel? _deleteModel;
  DeleteAccoutModel? get deleteModel => _deleteModel;
  Future<bool> deleteAccount({required BuildContext context}) async {
    _isLoading = true;
    _deleteModel = await deleteUserService.deleteUser(context);
    _isLoading = false;
    notifyListeners();
    if (_deleteModel?.success == true) {
      return true;
    }
    return false;
  }
}
