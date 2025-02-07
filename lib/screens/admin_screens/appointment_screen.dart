import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/models/upcoming_appointment_model.dart';
import 'package:vaidraj/provider/appointment_provider.dart';
import 'package:vaidraj/screens/admin_screens/prescription_page.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import '../../constants/text_size.dart';
import '../../provider/get_brach_provider.dart';
import '../../provider/prescription_provider.dart';
import '../../utils/border_helper/border_helper.dart';
import '../../utils/method_helper.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/loader.dart';
import '../../widgets/primary_btn.dart';
import '../home/home_screen.dart';

class AdminAppointmentScreen extends StatefulWidget {
  const AdminAppointmentScreen({super.key});

  @override
  State<AdminAppointmentScreen> createState() => _AdminAppointmentScreenState();
}

class _AdminAppointmentScreenState extends State<AdminAppointmentScreen>
    with NavigateHelper {
  String? role;
  // String? branchId;

  Future<void> loadRole() async {
    role = await SharedPrefs.getRole();
    print('$role');
  }

  Future<void> loadBranchId() async {
    var doctorAppointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    var branchProvider = Provider.of<GetBrachProvider>(context, listen: false);

    await doctorAppointmentProvider.setBranchId();
    doctorAppointmentProvider.initPaginController(context: context);
    branchProvider.getBranch(context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRole();
    loadBranchId();
  }

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
              screenIndex: 0,
            ));
      },
      child: Consumer2<AppointmentProvider, GetBrachProvider>(
        builder: (context, doctorAppointmentProvider, brachProvider, child) =>
            doctorAppointmentProvider.isLoading
                ? Center(
                    child: Loader(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        height: 8.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            brachProvider.isLoading
                                ? Center(
                                    child: Loader(),
                                  )
                                : role == "admin"
                                    ? CustomDropDownWidget(
                                        value: doctorAppointmentProvider
                                                .branchId ??
                                            '0',
                                        decoration:
                                            BorderHelper.dropDownOutlinedBorder(
                                                suffixIcon:
                                                    Icons.keyboard_arrow_down),
                                        items: brachProvider.getBranchModel
                                                    ?.data?.isNotEmpty ==
                                                true
                                            ? List<
                                                DropdownMenuItem<
                                                    Object?>>.generate(
                                                brachProvider.getBranchModel
                                                        ?.data?.length ??
                                                    0,
                                                (index) {
                                                  return DropdownMenuItem(
                                                    value: brachProvider
                                                            .getBranchModel
                                                            ?.data?[index]
                                                            .id
                                                            .toString() ??
                                                        "",
                                                    child: Text(
                                                      brachProvider
                                                              .getBranchModel
                                                              ?.data?[index]
                                                              .branchName ??
                                                          "-",
                                                      style: TextSizeHelper
                                                          .smallHeaderStyle,
                                                    ),
                                                  );
                                                },
                                              )
                                            : [
                                                DropdownMenuItem(
                                                  value: 0,
                                                  child: Text(
                                                    "No Branch Found",
                                                    style: TextSizeHelper
                                                        .smallHeaderStyle,
                                                  ),
                                                )
                                              ],
                                        onChanged: (value) {
                                          doctorAppointmentProvider.setBranchId(
                                              branchId: value as String);
                                          doctorAppointmentProvider
                                              .pagingController
                                              .refresh();
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return "Please select Disease !!";
                                          }
                                          return null;
                                        },
                                      )
                                    : const SizedBox.shrink(),
                            MethodHelper.widthBox(width: 2.w),
                            Consumer<AppointmentProvider>(
                              builder:
                                  (context, doctorAppointmentProvider, child) =>
                                      GestureDetector(
                                /// choose new date
                                onTap: () => doctorAppointmentProvider
                                    .chooseDateAppointments(context: context),
                                child: CustomContainer(
                                  padding: EdgeInsets.all(AppSizes.size10),
                                  borderColor: AppColors.brownColor,
                                  borderWidth: 1,
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.size30),
                                  height: 6.h,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(doctorAppointmentProvider.date),
                                      MethodHelper.widthBox(width: 2.w),
                                      const Icon(
                                        Icons.calendar_month,
                                        color: AppColors.brownColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: PagedListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    endIndent: 5.w,
                                    indent: 5.w,
                                    height: 2.h,
                                  ),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.h),
                              pagingController:
                                  doctorAppointmentProvider.pagingController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      UpcomingAppointmentInfo>(
                                  itemBuilder: (context, item, index) =>
                                      CustomContainer(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: AppSizes.size10),
                                        padding: const EdgeInsets.all(
                                            AppSizes.size10),
                                        width: 80.w,
                                        backGroundColor:
                                            AppColors.lightBackGroundColor,
                                        borderColor: AppColors.brownColor,
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.size10),
                                        borderWidth: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.name ?? 'Unknown',
                                                    style: TextSizeHelper
                                                        .smallHeaderStyle,
                                                  ),
                                                ),
                                                Text(
                                                  item.date ?? 'No date',
                                                  style: TextSizeHelper
                                                      .smallTextStyle,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${item.status}"
                                                      .toUpperCase(),
                                                  style: TextSizeHelper
                                                      .xSmallHeaderStyle
                                                      .copyWith(
                                                          color: AppColors
                                                              .errorColor),
                                                ),
                                              ],
                                            ),
                                            MethodHelper.heightBox(height: 1.h),
                                            Text(
                                              "Appointment Slot : ${item.slot}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                            Text(
                                              "Subject  : ${item.subject}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                            Text(
                                              "Message : ${item.message}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                PrimaryBtn(
                                                  btnText: "Prescription",
                                                  onTap: () {
                                                    print(
                                                        "appointmentID => ${item.id} ");
                                                    Provider.of<PrescriptionStateProvider>(
                                                            context,
                                                            listen: false)
                                                        .emptyDiseaseListAfterSuccess();
                                                    push(
                                                        context,
                                                        PrescriptionPage(
                                                            isCreating: true,
                                                            appointmentId:
                                                                item.id ?? 0,
                                                            name:
                                                                item.name ?? "",
                                                            diseaseId:
                                                                item.diseaseId ??
                                                                    0));
                                                  },
                                                  height: 3.h,
                                                  width: 25.w,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  backGroundColor:
                                                      AppColors.whiteColor,
                                                  borderColor:
                                                      AppColors.brownColor,
                                                  textStyle: TextSizeHelper
                                                      .xSmallTextStyle
                                                      .copyWith(
                                                          color: AppColors
                                                              .brownColor),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))))
                    ],
                  ),
      ),
    );
  }
}
