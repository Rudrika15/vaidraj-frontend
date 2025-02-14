import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/medical_history_model.dart' as m;
import 'package:vaidraj/models/product_model.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../models/upcoming_appointment_model.dart';
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
  m.MedicalHistoryListModel? patientsHistoryModel;
  ProductModel? productModel;
  final ProductService productService = ProductService();
  final MedicalHistoryService service = MedicalHistoryService();
  bool isLoading = true; // Track loading state
  String? role;
  @override
  void initState() {
    super.initState();
    initModel();
  }

  // Fetch data asynchronously
  Future<void> initModel() async {
    try {
      role = await SharedPrefs.getRole();
      isLoading = true;
      patientsHistoryModel = null;
      patientsHistoryModel =
          await service.getMedicalHistoryById(context: context, id: widget.id);
      productModel = await productService.getAllProduct(context: context);
      print("data collected");
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
    return RefreshIndicator(
      onRefresh: () async {
        await initModel();
      },
      child: Scaffold(
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
                  m.Appointments? item =
                      patientsHistoryModel?.data?.data?.appointments?[index];
                  return CustomContainer(
                    margin:
                        const EdgeInsets.symmetric(vertical: AppSizes.size10),
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
                                  style: TextSizeHelper.smallHeaderStyle
                                      .copyWith(
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
                        if (item?.status == "completed") ...[
                          Text(
                            "Prescriptions :-",
                            style: TextSizeHelper.xSmallHeaderStyle,
                          ),
                          for (m.Prescriptions p
                              in item?.prescriptions ?? []) ...[
                            for (Medicines m in p.medicines ?? []) ...[
                              Divider(
                                thickness: 0.5,
                              ),
                              Text(
                                "Medicine  : ${productModel?.data?.data?.firstWhere((e) => e.id.toString() == m.productId).productName}",
                                style: TextSizeHelper.xSmallTextStyle,
                              ),
                              Text(
                                "Timing  : ${m.time ?? "Not Found"}",
                                style: TextSizeHelper.xSmallTextStyle,
                              ),
                              Text(
                                "How To Take? : ${m.toBeTaken ?? "Not Found"}",
                                style: TextSizeHelper.xSmallTextStyle,
                              ),
                            ]
                          ],
                        ],
                        Divider(
                          thickness: 0.5,
                        ),
                        if (item?.prescriptions?.isNotEmpty == true) ...[
                          Text(
                            'Note : ${item?.prescriptions?[0].note ?? "Not Provided"}',
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          if (item?.prescriptions?[0].otherMedicines
                                  ?.isNotEmpty ==
                              true)
                            Text(
                              'Other Medicines : ${item?.prescriptions?[0].otherMedicines ?? "Not Provided"}',
                              style: TextSizeHelper.xSmallTextStyle,
                            ),
                        ] else ...[
                          Text(
                            'Subject : ${item?.subject ?? "Not Provided"}',
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                          Text(
                            'Message : ${item?.message ?? "Not Provided"}',
                            style: TextSizeHelper.xSmallTextStyle,
                          ),
                        ],
                        MethodHelper.heightBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (item?.status != "completed" &&
                                role != "manger") ...[
                              PrimaryBtn(
                                btnText: "Prescription",
                                onTap: () {
                                  print("appointmentID => ${item?.id} ");
                                  Provider.of<PrescriptionStateProvider>(
                                          context,
                                          listen: false)
                                      .emptyDiseaseListAfterSuccess();

                                  /// this will wait for value if i have updated somthing in forward page
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => PrescriptionPage(
                                              isCreating:
                                                  item?.status != "completed",
                                              appointmentId: item?.id ?? 0,
                                              name: item?.name ?? "",
                                              pId: item?.prescriptions
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? (item?.prescriptions?[0]
                                                          .id) ??
                                                      0
                                                  : -1,
                                              previousPrescriptionDisease:
                                                  item?.status == "completed"
                                                      ? (item?.prescriptions?[0]
                                                          .medicines)
                                                      : null,
                                              diseaseId: item?.diseaseId ?? 0)))
                                      .then((value) {
                                    if (value == true) {
                                      initModel();
                                    } else {
                                      print("not updated");
                                    }
                                  });
                                },
                                height: 3.h,
                                width: 25.w,
                                borderRadius: BorderRadius.circular(5),
                                backGroundColor: AppColors.whiteColor,
                                borderColor: AppColors.brownColor,
                                textStyle: TextSizeHelper.xSmallTextStyle
                                    .copyWith(color: AppColors.brownColor),
                              )
                            ] else ...[
                              Expanded(child: SizedBox())
                            ],
                            if (MethodHelper.isToday(item?.date ?? ""))
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.errorColor,
                                  ))
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
