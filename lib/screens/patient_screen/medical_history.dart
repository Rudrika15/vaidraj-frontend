import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/provider/medical_history_provider.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<MedicalHistoryProvider>(context, listen: false);
    provider.pagingController.addPageRequestListener((pageKey) {
      provider.fetchPage(pageKey: pageKey, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalHistoryProvider>(
        builder: (context, mHistoryModel, child) => PagedListView(
            pagingController: mHistoryModel.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Appointments>(
              itemBuilder: (context, item, index) => CustomContainer(
                borderColor: AppColors.brownColor,
                borderRadius: BorderRadius.circular(AppSizes.size10),
                borderWidth: 1,
                // width: 80.w,
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
                        Text('2007-01-01')
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
