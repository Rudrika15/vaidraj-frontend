import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/delete_account_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';

import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../mobile_verification/mobile_verification.dart';

class DeleteAccountScreen extends StatelessWidget with NavigateHelper {
  const DeleteAccountScreen({super.key});

  void _confirmDeletion(
      BuildContext context, LocalizationProvider langProvider) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(langProvider.translate('confirmDelAcc')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                langProvider.translate('cancel'),
                style: TextSizeHelper.smallTextStyle
                    .copyWith(color: AppColors.brownColor),
              ),
            ),
            TextButton(
                onPressed: () async {
                  bool success = await context
                      .read<DeleteUserProvider>()
                      .deleteAccount(context: context);
                  if (success) {
                    pop(context);
                    await SharedPrefs.clearShared();
                    pushRemoveUntil(context, MobileVerification());
                    WidgetHelper.customSnackBar(context: context, title: "");
                  } else {
                    WidgetHelper.customSnackBar(
                        context: context, title: "", isError: true);
                  }
                },
                child: Text(
                  langProvider.translate('delete'),
                  style: TextSizeHelper.smallTextStyle
                      .copyWith(color: AppColors.errorColor),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    LocalizationProvider langProvider = context.read<LocalizationProvider>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              margin: EdgeInsets.only(top: 3.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              alignment: Alignment.center,
              child: Text(
                langProvider.translate('confirmDeleteMessage'),
                style: TextSizeHelper.smallTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
            CustomContainer(
              margin: EdgeInsets.only(top: 5.h),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => _confirmDeletion(context, langProvider),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(langProvider.translate('deleteAcc'),
                    style: TextSizeHelper.smallTextStyle
                        .copyWith(color: AppColors.whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
