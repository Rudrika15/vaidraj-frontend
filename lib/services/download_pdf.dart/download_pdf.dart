import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/src/response.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import '../../utils/widget_helper/widget_helper.dart';

class DownloadPdfService {
  Future<void> downloadPdf(
      BuildContext context, int prescriptionId, String disease) async {
    try {
      Response response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getPrescriptionPdf(prescriptionId: prescriptionId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final responseBody = jsonDecode(response.body);
        // if (responseBody['code'] == Strings.apiSuccess) {
        final directory = await getTemporaryDirectory();

        String filePath;
        filePath =
            "${directory.path}/$disease.prescription_${DateTime.now().toString().replaceAll(" ", "_")}.csv";

        File file = await File(filePath).create();
        File fileData = await file.writeAsBytes(response.bodyBytes);

        WidgetHelper.customSnackBar(
          context: context,
          title: 'Download successfully',
        );
        // return true;
      } else {
        // return false;
      }
    } catch (e) {
      print("error while downloding pdf => $e");
      // return false;
    }
  }
}
