import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../provider/prescription_provider.dart';
import '../../widgets/primary_btn.dart';
import 'prescription_page.dart';

class PatientsHistoryScreen extends StatefulWidget {
  const PatientsHistoryScreen(
      {super.key, required this.id, required this.name});
  final int id;
  final String name;
  @override
  State<PatientsHistoryScreen> createState() => _RenderPatientsHistoryState();
}

class _RenderPatientsHistoryState extends State<PatientsHistoryScreen>
    with NavigateHelper {
  MedicalHistoryListModel? patientsHistoryModel;
  final MedicalHistoryService service = MedicalHistoryService();
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    initModel();
  }

  // Fetch data asynchronously
  Future<void> initModel() async {
    try {
      patientsHistoryModel =
          await service.getMedicalHistoryById(context: context, id: widget.id);
    } catch (error) {
      // Handle error gracefully, maybe show an error message
      print('Error fetching medical history: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading after the data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child:
              Loader(), // Show a loading indicator while data is being fetched
        ),
      );
    }

    // When data is loaded
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        title: Text(
          "${widget.name} History",
          overflow: TextOverflow.ellipsis,
          style: TextSizeHelper.mediumHeaderStyle
              .copyWith(color: AppColors.brownColor),
        ),
      ),
      body: patientsHistoryModel?.data?.data?.appointments?.isEmpty == true ||
              patientsHistoryModel?.data?.total == 0
          ? Center(
              child: Text('No Data Found'),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              itemCount:
                  patientsHistoryModel?.data?.data?.appointments?.length ?? 0,
              itemBuilder: (context, index) {
                print(index);
                Appointments? item =
                    patientsHistoryModel?.data?.data?.appointments?[index];
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
                                item?.status?.toUpperCase() ?? "",
                                style: TextSizeHelper.smallHeaderStyle.copyWith(
                                    color: item?.status == 'completed'
                                        ? AppColors.greenColor
                                        : AppColors.errorColor),
                              )),
                          MethodHelper.widthBox(width: 2.w),
                          Text(
                            item?.date ?? "",
                            style: TextSizeHelper.xSmallHeaderStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Patient : ${item?.name}",
                                style: TextSizeHelper.xSmallHeaderStyle,
                              )),
                        ],
                      ),
                      MethodHelper.heightBox(height: 1.h),
                      if (item?.prescriptions?.isNotEmpty == true) ...[
                        Text(
                          'Note : ${item?.prescriptions?[0].note}',
                          style: TextSizeHelper.xSmallTextStyle,
                        ),
                        if (item?.prescriptions?[0].otherMedicines
                                ?.isNotEmpty ==
                            true)
                          Text(
                            'Other Medicines : ${item?.prescriptions?[0].otherMedicines}',
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                      ] else ...[
                        Text(
                          'Subject : ${item?.subject}',
                          style: TextSizeHelper.xSmallTextStyle,
                        ),
                        Text(
                          'Message : ${item?.message}',
                          style: TextSizeHelper.xSmallTextStyle,
                        ),
                      ],
                      MethodHelper.heightBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryBtn(
                            btnText: "Prescription",
                            onTap: () {
                              print("appointmentID => ${item?.id} ");
                              Provider.of<PrescriptionStateProvider>(context,
                                      listen: false)
                                  .emptyDiseaseListAfterSuccess();
                              push(
                                  context,
                                  PrescriptionPage(
                                      isCreating: item?.status == "completed",
                                      appointmentId: item?.id ?? 0,
                                      name: item?.name ?? "",
                                      previousPrescriptionDisease:
                                          item?.status == "completed"
                                              ? (item
                                                  ?.prescriptions?[0].medicines)
                                              : null,
                                      diseaseId: item?.diseaseId ?? 0));
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
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
