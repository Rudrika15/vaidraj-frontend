import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vaidraj/models/all_disease_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class AllDiseaseService {
  Future<AllDieseasesModel?> getDieases(
      {required BuildContext context,
      required int currentPage,
      int? perPage}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.allDiseases(
              currentPage: currentPage, perPage: perPage));
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          AllDieseasesModel model = AllDieseasesModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting All Diseases => $e");
      return null;
    }
  }

  Future<List<Diseases>> getDiseaseByPage(
      {required BuildContext context,
      required int currentPage,
      int? perPage}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.allDiseases(
              currentPage: currentPage, perPage: perPage ?? 5));
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          AllDieseasesModel model = AllDieseasesModel.fromJson(data);
          return model.data?.data ?? [];
        }
      }
      return [];
    } catch (e) {
      print("error while getting disease by page => $e");
      return [];
    }
  }
}
