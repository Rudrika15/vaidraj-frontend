import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/models/todays_appointment_model.dart';
import 'package:vaidraj/provider/appointment_provider.dart';
import 'package:vaidraj/provider/prescription_provider.dart';
import 'package:vaidraj/screens/patient_screen/view_product_or_appointment.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../constants/text_size.dart';
import '../../utils/method_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_exit_dialog_widget.dart';
import '../../widgets/in_app_heading.dart';
import '../../widgets/primary_btn.dart';
import 'prescription_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        showDialog(
            context: context,
            builder: (context) => CustomAlertBox(
                content: "Do you really want to exit?",
                heading: "Exit App",
                secondBtnText: "Exit",
                color: AppColors.errorColor,
                onPressedSecondBtn: () => SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop')));
      },
      child: ListView(
        children: const [
          InScreenHeading(heading: "AppointMent"),

          /// render appointment
          RenderTodaysAppointments()
        ],
      ),
    );
  }
}

class RenderTodaysAppointments extends StatefulWidget {
  const RenderTodaysAppointments({super.key});

  @override
  State<RenderTodaysAppointments> createState() =>
      _RenderTodaysAppointmentsState();
}

class _RenderTodaysAppointmentsState extends State<RenderTodaysAppointments>
    with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<AppointmentProvider>(context, listen: false);
    provider.getTodaysAppointments(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        return appointmentProvider.isLoading
            ? Center(
                child: Loader(),
              )
            : appointmentProvider.todaysAppointmentModel?.data?.isEmpty == true
                ? SizedBox(
                    height: 60.h,
                    child: Center(
                      child: Text(
                        "No Appointment Today",
                        style: TextSizeHelper.smallHeaderStyle
                            .copyWith(color: AppColors.brownColor),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    itemBuilder: (context, index) {
                      TodaysAppointment? appointment = appointmentProvider
                          .todaysAppointmentModel?.data?[index];
                      return CustomContainer(
                        margin: const EdgeInsets.symmetric(
                            vertical: AppSizes.size10),
                        padding: const EdgeInsets.all(AppSizes.size10),
                        width: 80.w,
                        backGroundColor: AppColors.lightBackGroundColor,
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
                              children: [
                                Expanded(
                                  child: Text(
                                    appointment?.name ?? 'Unknown',
                                    style: TextSizeHelper.smallHeaderStyle,
                                  ),
                                ),
                                Text(
                                  appointment?.date ?? 'No date',
                                  style: TextSizeHelper.smallTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${appointment?.status}".toUpperCase(),
                                  style: TextSizeHelper.xSmallHeaderStyle
                                      .copyWith(color: AppColors.errorColor),
                                ),
                              ],
                            ),
                            MethodHelper.heightBox(height: 1.h),
                            Text(
                              "Appointment Slot : ${appointment?.slot}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Text(
                              "Disease : ${appointment?.diseases?.diseaseName}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Text(
                              "Date of Birth : ${appointment?.dob}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Text(
                              "Subject  : ${appointment?.subject}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Text(
                              "Message : ${appointment?.message}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Text(
                              "Address : ${appointment?.address}",
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PrimaryBtn(
                                  btnText: "Prescription",
                                  onTap: () {
                                    print(
                                        "appointmentID => ${appointment?.id} ");
                                    Provider.of<PrescriptionStateProvider>(
                                            context,
                                            listen: false)
                                        .emptyDiseaseListAfterSuccess();
                                    push(
                                        context,
                                        PrescriptionPage(
                                            isCreating: true,
                                            appointmentId: appointment?.id ?? 0,
                                            name: appointment?.name ?? "",
                                            diseaseId:
                                                appointment?.diseaseId ?? 0));
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
                    },
                    separatorBuilder: (context, index) =>
                        MethodHelper.widthBox(width: 2.w),
                    itemCount: appointmentProvider
                            .todaysAppointmentModel?.data?.length ??
                        0,
                  );
      },
    );
  }
}
