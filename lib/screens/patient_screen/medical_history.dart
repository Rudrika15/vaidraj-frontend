import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/services/download_pdf.dart/download_pdf.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';

import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../home/home_screen.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen>
    with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // will send user to my property page on back btn press
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        String role = await SharedPrefs.getRole();
        pushRemoveUntil(
            context,
            HomeScreen(
              isAdmin: role == "admin",
              isDoctor: role == "doctor",
              screenIndex: 3,
            ));
      },
      child: Consumer<LocalizationProvider>(
          builder: (context, langProvider, child) => StreamBuilder<String>(
                stream: langProvider.localeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Loader());
                  } else {
                    bool isEnglish = snapshot.data == "en";
                    return isEnglish
                        ? RenderMedicalHistory()
                        : RenderMedicalHistory();
                  }
                },
              )),
    );
  }
}

class RenderMedicalHistory extends StatefulWidget {
  const RenderMedicalHistory({super.key});

  @override
  State<RenderMedicalHistory> createState() => _RenderMedicalHistoryState();
}

class _RenderMedicalHistoryState extends State<RenderMedicalHistory> {
  /// paging controller
  final PagingController<int, Appointments> pagingController =
      PagingController<int, Appointments>(firstPageKey: 1);
  final MedicalHistoryService service = MedicalHistoryService();
  final DownloadPdfService pdfService = DownloadPdfService();

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey: pageKey, context: context);
    });
  }

  Future<void> fetchPage(
      {required int pageKey, required BuildContext context}) async {
    try {
      MedicalHistoryListModel? newItems = await service.getMedicalHistory(
        context: context,
        currentPage: pageKey,
      );

      // Filter out appointments without prescriptions
      var appointmentsWithPrescriptions = newItems?.data?.data?.appointments
              ?.where((appointment) =>
                  appointment.prescriptions?.isNotEmpty ?? false)
              .toList() ??
          [];

      final isLastPage = (appointmentsWithPrescriptions.length <
          (newItems?.data?.data?.appointments?.length ?? 0));

      if (isLastPage) {
        pagingController.appendLastPage(appointmentsWithPrescriptions);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(appointmentsWithPrescriptions, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Appointments>(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Appointments>(
        itemBuilder: (context, item, index) {
          return CustomContainer(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.size10),
            padding: const EdgeInsets.all(AppSizes.size10),
            width: 80.w,
            borderColor: AppColors.brownColor,
            borderRadius: BorderRadius.circular(AppSizes.size10),
            borderWidth: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          item.prescriptions?[0].user?.name ?? "",
                          style: TextSizeHelper.smallHeaderStyle
                              .copyWith(color: AppColors.brownColor),
                        )),
                    MethodHelper.widthBox(width: 2.w),
                    Text(
                      item.date ?? "",
                      style: TextSizeHelper.xSmallHeaderStyle,
                    ),
                  ],
                ),
                MethodHelper.heightBox(height: 1.h),
                Text(
                  'Note : ${item.prescriptions?[0].note}',
                  style: TextSizeHelper.xSmallTextStyle,
                ),
                if (item.prescriptions?[0].otherMedicines?.isNotEmpty == true)
                  Text(
                    'Other Medicines : ${item.prescriptions?[0].otherMedicines}',
                    style: TextSizeHelper.xSmallTextStyle,
                  ),
                MethodHelper.heightBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pdfService.downloadPdf(
                            context,
                            item.prescriptions?[0].id ?? 0,
                            item.prescriptions?[0].diseaseId.toString() ?? "");
                      },
                      child: CustomContainer(
                        padding: const EdgeInsets.all(AppSizes.size10 - 5),
                        borderColor: AppColors.brownColor,
                        borderRadius: BorderRadius.circular(AppSizes.size10),
                        borderWidth: 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.download,
                              color: AppColors.brownColor,
                              size: AppSizes.size10 + 5,
                            ),
                            MethodHelper.widthBox(width: 2.w),
                            Text(
                              'Get Prescription',
                              style: TextSizeHelper.xSmallTextStyle,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return Center(
            child: Text(
              'No Medical History Found',
              style: TextSizeHelper.smallHeaderStyle,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
