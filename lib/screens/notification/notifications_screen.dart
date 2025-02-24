import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/get_notifications_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/feedback/feedback.dart';
import 'package:vaidraj/services/notifications/get_notifications_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/icon_btn_widget.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../constants/color.dart';
import '../../constants/text_size.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  final GetNotificationsService service = GetNotificationsService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            surfaceTintColor: AppColors.whiteColor,
            title: Text(
              langProvider.translate('notification'),
              style: TextSizeHelper.mediumTextStyle
                  .copyWith(color: AppColors.brownColor),
            ),
          ),
          body: FutureBuilder(
            future: service.getNotifications(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Loader(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  langProvider.translate('noDataFound'),
                  style: TextSizeHelper.smallHeaderStyle
                      .copyWith(color: AppColors.brownColor),
                ));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Notification1? notification = snapshot.data?.data?[index];
                  return NotificationWidget(
                      message: notification?.message ?? "",
                      langProvider: langProvider);
                },
                // children: [
                //   NotificationWidget(
                //     message: "Message",
                //     langProvider: langProvider,
                //   ),
                //   NotificationWidget(
                //     message: "Message",
                //     langProvider: langProvider,
                //   ),
                //   NotificationWidget(
                //     message: "Message",
                //     langProvider: langProvider,
                //   ),
                //   NotificationWidget(
                //     message: "Message",
                //     langProvider: langProvider,
                //   ),
                // ],
              );
            },
          )),
    );
  }
}

class NotificationWidget extends StatelessWidget with NavigateHelper {
  const NotificationWidget(
      {super.key, required this.message, required this.langProvider});
  final String message;
  final LocalizationProvider langProvider;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      padding: EdgeInsets.all(AppSizes.size10),
      // height: 15.h,
      width: 90.w,
      // backGroundColor: AppColors.backgroundColor,
      borderColor: AppColors.brownColor,
      borderWidth: 0.5,
      borderRadius: BorderRadius.circular(AppSizes.size10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: Text(message)),
              MethodHelper.widthBox(width: AppSizes.size10),
              GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.brownColor,
                  ))
            ],
          ),
          MethodHelper.heightBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryBtn(
                btnText: langProvider.translate("feedback"),
                onTap: () {
                  // add logic to email
                  push(context, const FeedbackScreen());
                },
                height: 3.h,
                width: 25.w,
                borderRadius: BorderRadius.circular(5),
                backGroundColor: AppColors.whiteColor,
                borderColor: AppColors.brownColor,
                textStyle: TextSizeHelper.xSmallTextStyle
                    .copyWith(color: AppColors.brownColor),
              ),
              MethodHelper.widthBox(width: 2.w),
              PrimaryBtn(
                btnText: langProvider.translate("call"),
                onTap: () {
                  // add logic to call
                  MethodHelper.dialNumber(AppStrings.mobile);
                },
                height: 3.h,
                width: 25.w,
                borderRadius: BorderRadius.circular(5),
                backGroundColor: AppColors.whiteColor,
                borderColor: AppColors.brownColor,
                textStyle: TextSizeHelper.xSmallTextStyle
                    .copyWith(color: AppColors.brownColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
