import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/screens/mobile_verification/mobile_verification.dart';
import 'package:vaidraj/screens/no_intenet_connection/no_internet_connection.dart';
import 'package:vaidraj/screens/splash_screen/splash.dart';
import '../widget_helper/widget_helper.dart';
import '../shared_prefs_helper.dart/shared_prefs_helper.dart';

class HttpHelper {
  // For GET method
  static Future<dynamic> get({
    required BuildContext context,
    required String uri,
    Map<String, String>? headers,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      String bearerToken = token;
      var header = {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      };

      final client = RetryClient(http.Client());
      var url = Uri.parse(uri);

      var response = await client.get(url, headers: headers ?? header);

      if (context.mounted) {
        return httpErrorHandling(response, context);
      }
    } catch (e) {
      noInternetConnection(e, context);
      throw Exception(e);
    }
  }

  static void noInternetConnection(Object e, BuildContext context) {
    if (e is SocketException) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NoInternetPage(
              onRetry: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                    (route) => false,
                  )),
        ),
        (route) => false,
      );
    } else {
      WidgetHelper.customSnackBar(
        context: context,
        title: 'Something went Wrong!',
        color: AppColors.whiteColor,
        isError: true,
      );
    }
  }

  static Future<dynamic> delete({
    required BuildContext context,
    required String uri,
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      String bearerToken = token;
      var header = {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      };

      final client = RetryClient(http.Client());
      var url = Uri.parse(uri);

      var response =
          await client.delete(url, headers: headers ?? header, body: body);
      print(response.body);
      if (context.mounted) {
        return httpErrorHandling(response, context);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // For POST method
  static Future<dynamic> post({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
  }) async {
    var token = await SharedPrefs.getToken();

    var header = {
      "Authorization": "Bearer $token",
    };
    var url = Uri.parse(uri);
    var response = await http.post(
      url,
      body: body,
      headers: headers ?? header,
      encoding: encoding,
    );
    print(response.body);
    if (context.mounted) {
      return httpErrorHandling(response, context);
    }
  }

  // For PUT method
  static Future<dynamic> put({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
  }) async {
    var token = await SharedPrefs.getToken();

    var header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    var url = Uri.parse(uri);
    var response = await http.put(
      url,
      body: body,
      headers: headers ?? header,
      encoding: encoding,
    );
    print(response.body);
    if (context.mounted) {
      return httpErrorHandling(response, context);
    }
  }

  static Future<dynamic> multipart({required String uri}) async {
    try {
      var token = await SharedPrefs.getToken();

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
      };
      MultipartRequest response = http.MultipartRequest('POST', Uri.parse(uri));
      response.headers.addAll(headers);

      return response;
    } catch (e) {
      print(e);
    }
  }

  // error handling for http methods
  static Response httpErrorHandling(Response response, BuildContext context) {
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (context.mounted) {
        var data = jsonDecode(response.body);
        WidgetHelper.customSnackBar(
          isError: true,
          context: context,
          title: data['message'] != null
              ? data['message'].toString()
              : data['exception'] != null
                  ? data['exception'].toString()
                  : data['error'] != null
                      ? data['error'].toString()
                      : 'Something went wrong',
          // data['code'].toString(),
          color: AppColors.errorColor,
        );
        if (response.statusCode == 401) {
          print(response.body);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MobileVerification(),
              ),
              (route) => false);
          return response;
        }

        return response;
      } else if (response.statusCode == 401) {
        print(response.body);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MobileVerification(),
            ),
            (route) => false);
        return response;
      } else {
        print(response.body);
        WidgetHelper.customSnackBar(
          isError: true,
          context: context,
          title: 'Something went Wrong!',
          color: AppColors.errorColor.withOpacity(0.2),
        );
        return response;
      }
    } else {
      return response;
    }
  }
}
