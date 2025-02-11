import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/src/response.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';
import '../../utils/method_helper.dart';
import '../../utils/widget_helper/widget_helper.dart';

class DownloadPdfService {
  Future<void> downloadPdf(
      BuildContext context, int prescriptionId, String disease) async {
    try {
      // Check if permission is granted before proceeding with the download
      if (await MethodHelper.requestStoragePermission(context)) {
        Response response = await HttpHelper.get(
          context: context,
          uri: ApiHelper.getPrescriptionPdf(prescriptionId: prescriptionId),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final directory = await getExternalStorageDirectories();
          String filePath =
              "${directory?[0].path}/$disease.prescription_${DateTime.now().toString().replaceAll(" ", "_")}.pdf";
          print(filePath);

          // Create and write the PDF file
          File file = await File(filePath).create();
          await file.writeAsBytes(response.bodyBytes);

          // Open the file automatically after it's downloaded
          //Support for custom add types

          await OpenFilex.open(
            filePath,
          );

          // Show success message
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Download successful',
          );
        } else {
          // Handle failure (optional)
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Download failed',
            isError: true,
          );
        }
      } else {
        // If permission is not provided, show a failure message
        WidgetHelper.customSnackBar(
          context: context,
          title: 'Permission not provided. Cannot download file.',
          isError: true,
        );
      }
    } catch (e) {
      print("Error while downloading PDF => $e");
      // Optionally show an error message to the user
      WidgetHelper.customSnackBar(
        context: context,
        title: 'An error occurred while downloading',
        isError: true,
      );
    }
  }
}
