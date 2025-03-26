import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/models/todays_appointment_model.dart';
import 'package:vaidraj/provider/appointment_provider.dart';
import 'package:vaidraj/provider/prescription_provider.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
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
      child: const Column(
        children: [
          InScreenHeading(heading: "Appointment"),

          /// render appointment
          Expanded(child: RenderTodaysAppointments())
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
  String? role;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRole();
    var provider = Provider.of<AppointmentProvider>(context, listen: false);
    provider.getTodaysAppointments(context: context);
  }

  Future<void> getRole() async {
    role = await SharedPrefs.getRole();
  }

  @override
  Widget build(BuildContext context) {
    AppointmentProvider appointmentProvider =
        context.watch<AppointmentProvider>();
    return appointmentProvider.isLoading
        ? const Center(
            child: Loader(),
          )
        : appointmentProvider.todaysAppointmentModel?.data?.isNotEmpty == true
            ? RefreshIndicator(
                color: AppColors.brownColor,
                backgroundColor: AppColors.whiteColor,
                onRefresh: () async {
                  await appointmentProvider.getTodaysAppointments(
                      context: context);
                },
                child: ListView.separated(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                  itemBuilder: (context, index) {
                    TodaysAppointment? appointment = appointmentProvider
                        .todaysAppointmentModel?.data?[index];
                    return CustomContainer(
                      margin:
                          const EdgeInsets.symmetric(vertical: AppSizes.size10),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${appointment?.status}".toUpperCase(),
                                style: TextSizeHelper.xSmallHeaderStyle
                                    .copyWith(color: AppColors.errorColor),
                              ),
                              Text(
                                "Age : ${MethodHelper.calculateAge(birthDateString: appointment?.dob ?? "")}",
                                style: TextSizeHelper.xSmallHeaderStyle,
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
                            "Subject  : ${appointment?.subject ?? "Not Provided"}",
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          Text(
                            "Message : ${appointment?.message ?? "Not Provided"}",
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          Text(
                            "Address : ${appointment?.address}",
                            overflow: TextOverflow.ellipsis,
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          if (role != "manager") ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PrimaryBtn(
                                  height: 3.h,
                                  width: 30.w,
                                  btnText: "Prescription",
                                  onTap: () async {
                                    print(
                                        "appointmentID => ${appointment?.id} ");
                                    Provider.of<PrescriptionStateProvider>(
                                            context,
                                            listen: false)
                                        .emptyDiseaseListAfterSuccess();
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PrescriptionPage(
                                          isCreating: true,
                                          appointmentId: appointment?.id ?? 0,
                                          name: appointment?.name ?? "",
                                          pId: -1,
                                          diseaseId:
                                              appointment?.diseaseId ?? 0),
                                    ))
                                        .then((value) {
                                      if (value == true && value != null) {
                                        appointmentProvider
                                            .getTodaysAppointments(
                                                context: context);
                                      } else {
                                        print(
                                            "Nothing changed in todays appointment page");
                                      }
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  backGroundColor: AppColors.whiteColor,
                                  borderColor: AppColors.brownColor,
                                  textStyle: TextSizeHelper.xSmallTextStyle
                                      .copyWith(color: AppColors.brownColor),
                                )
                              ],
                            )
                          ]
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      MethodHelper.widthBox(width: 2.w),
                  itemCount: appointmentProvider
                          .todaysAppointmentModel?.data?.length ??
                      0,
                ),
              )
            : SizedBox(
                height: 60.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "No Appointment Today",
                        style: TextSizeHelper.smallHeaderStyle
                            .copyWith(color: AppColors.brownColor),
                      ),
                      MethodHelper.heightBox(height: 5.h),
                      SizedBox(
                        height: 5.h,
                        width: 25.w,
                        child: PrimaryBtn(
                            btnText: "Refresh",
                            textStyle: TextSizeHelper.smallTextStyle
                                .copyWith(color: AppColors.whiteColor),
                            onTap: () async {
                              appointmentProvider.getTodaysAppointments(
                                  context: context);
                            }),
                      )
                    ],
                  ),
                ),
              );
  }
}
