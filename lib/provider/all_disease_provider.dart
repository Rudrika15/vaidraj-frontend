import 'package:flutter/material.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/services/all_disease_service/all_disease_service.dart';

class AllDiseaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AllDieseasesModel? diseaseModel;

  AllDiseaseService service = AllDiseaseService();

  /// this will get all diseases with artical,video,products
  Future<void> getAllDisease({required BuildContext context}) async {
    _isLoading = true;
    diseaseModel = await service.getDieases(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
