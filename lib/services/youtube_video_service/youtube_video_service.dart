import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/models/youtube_video_model.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';

class YouTubeVideoService {
  Future<YoutubeVideoModel?> getYouTubeVideo(
    BuildContext context,
  ) async {
    try {
      Response response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getHomeScreenVideo,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          YoutubeVideoModel model = YoutubeVideoModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting recommanded videos => $e");
      return null;
    }
  }

  Future<YoutubeVideoModel?> getAllYouTubeVideo(
      {required BuildContext context,
      required int currentPage,
      int? perPage}) async {
    try {
      log(ApiHelper.getAllYTVideos(currentPage: currentPage, perPage: perPage));
      Response response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getAllYTVideos(
            currentPage: currentPage, perPage: perPage),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          YoutubeVideoModel model = YoutubeVideoModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
