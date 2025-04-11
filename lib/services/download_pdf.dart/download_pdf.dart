import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/src/response.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import '../../utils/widget_helper/widget_helper.dart';

class DownloadPdfService {
  Future<void> downloadPdf(
      BuildContext context, int prescriptionId, String disease) async {
    try {
      // Permission is not needed if using app-specific directory on Android 10+
      final Response response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getPrescriptionPdf(prescriptionId: prescriptionId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          throw Exception("Unable to access storage directory.");
        }

        String fileName =
            "prescription_${DateTime.now().toIso8601String()}.pdf";
        String filePath = "${directory.path}/$fileName";

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFilex.open(filePath);

        WidgetHelper.customSnackBar(
          context: context,
          title: 'Download successful',
        );
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: 'Download failed',
          isError: true,
        );
      }
    } catch (e) {
      WidgetHelper.customSnackBar(
        context: context,
        title: 'An error occurred while downloading',
        isError: true,
      );
    }
  }
}
