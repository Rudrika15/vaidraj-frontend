import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:vaidraj/models/product_model.dart';
import 'package:vaidraj/utils/api_helper/api_helper.dart';
import 'package:vaidraj/utils/http_helper/http_helper.dart';
import 'package:http/src/response.dart';

class ProductService {
  Future<ProductModel?> getProductWithPagination(
      {required BuildContext context, required int currentPage}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getProductsWithPagination(currentPage: currentPage));
      // log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          ProductModel model = ProductModel.fromJson(data);
          return model;
        } else {}
      }
      return null;
    } catch (e) {
      print("error while getting products with pagination => $e");
      return null;
    }
  }

  Future<ProductModel?> getProductDiseaseWise(
      {required BuildContext context, required int diseaseId}) async {
    try {
      Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getProductsDiseaseWise(diseaseId: diseaseId));
      // log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          ProductModel model = ProductModel.fromJson(data);
          return model;
        } else {}
      }
      return null;
    } catch (e) {
      print("error while getting products disease wise => $e");
      return null;
    }
  }
}
