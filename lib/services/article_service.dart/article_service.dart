import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/models/article_model.dart';

import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';

class ArticleService {
  Future<ArticleModel?> getAllArticle(
      {required BuildContext context,
      required int currentPage,
      int? perPage}) async {
    try {
      // log(ApiHelper.getAllYTVideos(currentPage: currentPage, perPage: perPage));
      Response response = await HttpHelper.get(
        context: context,
        uri:
            ApiHelper.getAllArticle(currentPage: currentPage, perPage: perPage),
      );
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          ArticleModel model = ArticleModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      log("error while getting article => $e");
      return null;
    }
  }
}
