import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/medical_history_provider.dart';
import 'package:vaidraj/services/download_pdf.dart/download_pdf.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../models/patient_medical_history_adminside.dart' as p;
import '../../models/patient_medical_history_adminside.dart';
import '../../models/product_model.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../home/home_screen.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen>
    with NavigateHelper {
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
      child: Consumer<LocalizationProvider>(
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
              )),
    );
  }
}

class RenderMedicalHistory extends StatefulWidget {
  const RenderMedicalHistory({super.key});

  @override
  State<RenderMedicalHistory> createState() => _RenderMedicalHistoryState();
}

class _RenderMedicalHistoryState extends State<RenderMedicalHistory> {
  final DownloadPdfService pdfService = DownloadPdfService();
  ProductModel? productModel;
  ProductService productService = ProductService();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<MedicalHistoryProvider>(context, listen: false);

    provider.getMedicalHistory(
      context: context,
    );

    if (productModel == null) {
      initProductModel();
    }
  }

  Future<void> initProductModel() async {
    try {
      productModel = await productService.getAllProduct(context: context);
      isLoading = false;
    } catch (e) {
      print(
          "error while getting product in medical history page patient side => $e");
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalHistoryProvider>(
      builder: (context, medicalHistoryModel, child) => RefreshIndicator(
        onRefresh: () async {},
        child: isLoading
            ? const Center(
                child: Loader(),
              )
            : medicalHistoryModel.medicalHistoryModel?.data?.data?.isEmpty ==
                    true
                ? Center(
                    child: Text(
                      'No Medical History Found',
                      style: TextSizeHelper.smallHeaderStyle,
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    itemCount: medicalHistoryModel
                            .medicalHistoryModel?.data?.data?.length ??
                        0,
                    itemBuilder: (context, index) {
                      PatientHistoryInfo? item = medicalHistoryModel
                          .medicalHistoryModel?.data?.data?[index];
                      return CustomContainer(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (p.Appointments a
                                  in item?.appointments ?? []) ...[
                                if (a.status == "completed") ...[
                                  CustomContainer(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: AppSizes.size10),
                                    padding:
                                        const EdgeInsets.all(AppSizes.size10),
                                    width: 80.w,
                                    borderColor: AppColors.brownColor,
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.size10),
                                    borderWidth: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (PatientWisePrescriptions pp
                                            in a.prescriptions ?? []) ...[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    pp.user?.name ?? "",
                                                    style: TextSizeHelper
                                                        .smallHeaderStyle
                                                        .copyWith(
                                                            color: AppColors
                                                                .brownColor),
                                                  )),
                                              MethodHelper.widthBox(width: 2.w),
                                              Text(
                                                a.date ?? "",
                                                style: TextSizeHelper
                                                    .xSmallHeaderStyle,
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                          Text(
                                            "Prescriptions :-",
                                            style: TextSizeHelper
                                                .xSmallHeaderStyle,
                                          ),
                                          for (PatientWiseMedicines m
                                              in pp.medicines ?? []) ...[
                                            Text(
                                              "Medicine  : ${productModel?.data?.data?.firstWhere((e) => e.id.toString() == m.productId).productName}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                            Text(
                                              "Timing  : ${m.time ?? "Not Found"}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                            Text(
                                              "How To Take? : ${m.toBeTaken ?? "Not Found"}",
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                          ],
                                          MethodHelper.heightBox(height: 1.h),
                                          if (pp.note != null)
                                            Text(
                                              'Note : ${pp.note}',
                                              style: TextSizeHelper
                                                  .xSmallTextStyle,
                                            ),
                                          if (pp.otherMedicines != "")
                                            const Divider(
                                              thickness: 0.5,
                                            ),
                                          Text(
                                            'Other Medicines : ${pp.otherMedicines}',
                                            style:
                                                TextSizeHelper.xSmallTextStyle,
                                          ),
                                          MethodHelper.heightBox(height: 1.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await pdfService.downloadPdf(
                                                      context,
                                                      pp.id ?? 0,
                                                      pp.diseaseId.toString());
                                                },
                                                child: CustomContainer(
                                                  padding: const EdgeInsets.all(
                                                      AppSizes.size10 - 5),
                                                  borderColor:
                                                      AppColors.brownColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppSizes.size10),
                                                  borderWidth: 0.5,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.download,
                                                        color: AppColors
                                                            .brownColor,
                                                        size:
                                                            AppSizes.size10 + 5,
                                                      ),
                                                      MethodHelper.widthBox(
                                                          width: 2.w),
                                                      Text(
                                                        'Get Prescription',
                                                        style: TextSizeHelper
                                                            .xSmallTextStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ]
                                      ],
                                    ),
                                  )
                                ]
                              ],
                            ]),
                      );
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    // pagingController.dispose();
    super.dispose();
  }
}
