import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
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
            ));
  }
}

class RenderMedicalHistory extends StatefulWidget {
  const RenderMedicalHistory({super.key});

  @override
  State<RenderMedicalHistory> createState() => _RenderMedicalHistoryState();
}

class _RenderMedicalHistoryState extends State<RenderMedicalHistory> {
  final PagingController<int, Appointments> pagingController =
      PagingController<int, Appointments>(firstPageKey: 1);
  final MedicalHistoryService service = MedicalHistoryService();
  @override
  void initState() {
    // TODO: implement initState
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
      final isLastPage =
          ((newItems?.data?.data?.appointments?.length ?? 0) < 5);
      if (isLastPage) {
        pagingController
            .appendLastPage(newItems?.data?.data?.appointments ?? []);
      } else {
        final nextPageKey = pageKey + 1;

        pagingController.appendPage(
            newItems?.data?.data?.appointments ?? [], nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Appointments>(
          itemBuilder: (context, item, index) {
            if (index >= 0 && item.prescriptions?.isEmpty == true) {
              if (index >= 1) {
                return const SizedBox.shrink();
              }
              return CustomContainer(
                alignment: Alignment.center,
                height: 90.h,
                child: Text(
                  'No Medical History Found',
                  style: TextSizeHelper.smallHeaderStyle,
                ),
              );
            }
            return CustomContainer(
              borderColor: AppColors.brownColor,
              borderRadius: BorderRadius.circular(AppSizes.size10),
              borderWidth: 1,
              margin: const EdgeInsets.only(bottom: AppSizes.size10),
              padding: const EdgeInsets.all(AppSizes.size10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                            item.name ?? "",
                            style: TextSizeHelper.smallHeaderStyle,
                          )),
                      MethodHelper.widthBox(width: 2.w),
                      Text(
                        item.date ?? "",
                        style: TextSizeHelper.smallTextStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Doctor :",
                            style: TextSizeHelper.smallHeaderStyle,
                          )),
                      MethodHelper.widthBox(width: 2.w),
                      Text(
                        item.prescriptions?[0].user?.name ?? "",
                        style: TextSizeHelper.smallTextStyle,
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pagingController.dispose();
  }
}
