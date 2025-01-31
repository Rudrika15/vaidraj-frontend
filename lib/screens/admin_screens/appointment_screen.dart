import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';
import 'package:vaidraj/widgets/custom_text_field_widget.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/loader.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  /// variables
  PrescriptionModel prescriptionModel = PrescriptionModel();
  TextEditingController patientNameController = TextEditingController();
  String disease = "";
  // List<String> selectedDisease = [];
  int diseaseId = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disease = "Depression";
    // selectedDisease.add("Depression");
    prescriptionModel =
        PrescriptionModel(diseases: [Diseases(diseaseName: disease)]);
    print(prescriptionModel.diseases?.first.diseaseName);
    ///// get all diseases
    var diseaseProvider =
        Provider.of<AllDiseaseProvider>(context, listen: false);
    if (diseaseProvider.diseasesModelForAppointment == null) {
      diseaseProvider.getAllDiseaseWithoutPagination(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllDiseaseProvider>(
      builder: (context, diseasesProvider, child) => SingleChildScrollView(
        child: Column(
          children: [
            paddingMethod(CustomTextFieldWidget(
                validator: (value) {},
                keyboardType: TextInputType.text,
                controller: patientNameController,
                decoration: MethodHelper.greenUnderLineBorder(
                    hintText: "Patient Name"))),
            paddingMethod(
              diseasesProvider.isLoading
                  ? const Center(
                      child: Loader(),
                    )
                  : CustomDropDownWidget(
                      value: disease,
                      alignment: Alignment.centerLeft,
                      prefixIcon: Icons.storefront_outlined,
                      decoration: MethodHelper.greenUnderLineBorder(
                          hintText: "Disease"),
                      items: diseasesProvider.diseasesModelForAppointment?.data
                                  ?.data?.isNotEmpty ==
                              true
                          ? List<DropdownMenuItem<Object?>>.generate(
                              diseasesProvider.diseasesModelForAppointment?.data
                                      ?.data?.length ??
                                  0,
                              (index) {
                                return DropdownMenuItem(
                                  value: diseasesProvider
                                          .diseasesModelForAppointment
                                          ?.data
                                          ?.data?[index]
                                          .displayName ??
                                      "-",
                                  child: Text(
                                    diseasesProvider.diseasesModelForAppointment
                                            ?.data?.data?[index].displayName ??
                                        "-",
                                    style: TextSizeHelper.smallHeaderStyle,
                                  ),
                                );
                              },
                            )
                          : [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  "No Diseases Found",
                                  style: TextSizeHelper.smallHeaderStyle,
                                ),
                              )
                            ],
                      onChanged: (value) {
                        /// only add disease if not already selected
                        setState(() {
                          if (!prescriptionModel.diseases!
                              .any((e) => e.diseaseName == value)) {
                            // selectedDisease.add(value as String);
                            prescriptionModel.diseases
                                ?.add(Diseases(diseaseName: value as String));
                            disease = value as String;
                            diseaseId = diseasesProvider
                                    .diseasesModelForAppointment?.data?.data
                                    ?.firstWhere((element) =>
                                        element.displayName == value)
                                    .id ??
                                0;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select Disease !!";
                        }
                        return null;
                      },
                    ),
            ),
            PrescriptionWidget(
                diseaseId: diseaseId,
                diseases: prescriptionModel.diseases![prescriptionModel.diseases
                        ?.indexWhere((e) => e.diseaseName == disease) ??
                    0]),
          ],
        ),
      ),
    );
  }

  Padding paddingMethod(Widget child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
        child: child,
      );
}

class PrescriptionWidget extends StatefulWidget {
  PrescriptionWidget(
      {super.key, required this.diseaseId, required this.diseases});
  final int diseaseId;
  final Diseases diseases;
  @override
  State<PrescriptionWidget> createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  /// variable
  // final List<Product> products = [];
  final ProductService service = ProductService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /// fectch and add product list
  Future<List<Products>?> getProductList() async {
    ProductModel? product = await service.getProductDiseaseWise(
        context: context, diseaseId: widget.diseaseId);
    print(product?.data?.data?.length);
    widget.diseases.products = List.generate(
        product?.data?.data?.length ?? 0,
        (index) => Products(
            id: product?.data?.data?[index].id ?? 0,
            name: product?.data?.data?[index].displayName ?? "-"));
    return widget.diseases.products;
  }

// List of products (for illustration)
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      // backGroundColor: AppColors.errorColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const CustomSearchBar(),
            FutureBuilder<List<Products>?>(
              future: getProductList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Loader(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error while Fetching',
                      style: TextSizeHelper.smallTextStyle,
                    ),
                  );
                } else {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.diseases.products?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = widget.diseases.products?[index];
                        return PrescriptionPageWidget(
                          productId: product?.id ?? 0,
                          productName: product?.name ?? "-",
                          onChanged: (isChecked) {
                            // Handle checkbox change if needed
                          },
                        );
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// A common widget for the prescription item with checkboxes and selectable buttons
class PrescriptionPageWidget extends StatefulWidget {
  final int productId;
  final String productName;
  final ValueChanged<bool> onChanged;
  PrescriptionPageWidget({
    required this.productId,
    required this.productName,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _PrescriptionItemWidgetState createState() => _PrescriptionItemWidgetState();
}

class _PrescriptionItemWidgetState extends State<PrescriptionPageWidget> {
  // Default selections for time of day and when to take
  String selectedWhenToTake = 'before meal';
  List<String> selectedTimeOfDay = []; // Store multiple time selections
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          // Checkbox for product selection
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
            child: Row(
              children: [
                Checkbox(
                  activeColor: AppColors.greenColor,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                      widget.onChanged(isChecked);
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    widget.productName,
                    style: TextSizeHelper.smallHeaderStyle,
                  ),
                ),
              ],
            ),
          ),

          // Show additional information if the product is selected
          if (isChecked) ...[
            // Time of the Day
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppSizes.size40),
                    child: Row(
                      children: [
                        Text('Time of the Day',
                            style: TextSizeHelper.smallTextStyle),
                      ],
                    ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSizes.size40),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            ['morning', 'noon', 'evening', 'night'].map((time) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!selectedTimeOfDay.contains(time)) {
                                  selectedTimeOfDay
                                      .add(time); // Add the selected time
                                } else {
                                  selectedTimeOfDay.remove(
                                      time); // Remove the deselected time
                                }
                              });
                            },
                            child: CustomContainer(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size20),
                              borderWidth: 1,
                              backGroundColor: selectedTimeOfDay.contains(time)
                                  ? AppColors.whiteColor
                                  : Colors.grey.shade300,
                              borderColor: selectedTimeOfDay.contains(time)
                                  ? AppColors.greenColor
                                  : Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.size20 - 5,
                                  vertical: AppSizes.size10 - 5),
                              child: Text(
                                time,
                                style: TextSizeHelper.xSmallHeaderStyle
                                    .copyWith(
                                        color: selectedTimeOfDay.contains(time)
                                            ? AppColors.greenColor
                                            : Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // When to Take
            MethodHelper.heightBox(height: 1.h),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppSizes.size40),
                    child: Row(
                      children: [
                        Text('When to Take',
                            style: TextSizeHelper.smallTextStyle),
                      ],
                    ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSizes.size40),
                      child: Row(
                        children: ['before meal', 'after meal'].map((when) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedWhenToTake = when;
                              });
                            },
                            child: CustomContainer(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size20),
                              borderWidth: 1,
                              backGroundColor: selectedWhenToTake == when
                                  ? AppColors.whiteColor
                                  : Colors.grey.shade300,
                              borderColor: selectedWhenToTake == when
                                  ? AppColors.greenColor
                                  : Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.size20 - 5,
                                  vertical: AppSizes.size10 - 5),
                              child: Text(
                                when,
                                style: TextSizeHelper.xSmallHeaderStyle
                                    .copyWith(
                                        color: selectedWhenToTake == when
                                            ? AppColors.greenColor
                                            : Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// class Product {
//   final int id;
//   final String name;

//   Product({required this.id, required this.name});
// }
