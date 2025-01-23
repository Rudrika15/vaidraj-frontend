import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/icon_btn_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

import '../../constants/color.dart';
import '../../constants/text_size.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
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
                        Expanded(
                            flex: 8,
                            child: Text(
                                "jhsdfuiwufuofuuefunqewuovqwitiienrnhiirriovirhghuerhgerrignnierviirrvierigiergierrigiewrigioierjgnierigwieurigoiwcerigwcoerogmowerogmiomweiurguwiougiow3ioicriughnuweriviowiotviwhe utiuitoiwentuqiovunituiqu4itvuqiiotv iovutioquotv uoiu tqiontoiqn3iotnqitquinitvqniun8tqu4t")),
                        MethodHelper.widthBox(width: AppSizes.size10),
                        Expanded(
                          child: CustomIconBtnWidget(
                              onPressed: () {}, icon: Icons.more_vert),
                        )
                      ],
                    ),
                    MethodHelper.heightBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryBtn(
                          btnText: langProvider.translate("sendEmail"),
                          onTap: () {
                            // add logic to email
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
                          },
                          height: 3.h,
                          width: 25.w,
                          borderRadius: BorderRadius.circular(5),
                          borderColor: AppColors.brownColor,
                          textStyle: TextSizeHelper.xSmallTextStyle
                              .copyWith(color: AppColors.whiteColor),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
