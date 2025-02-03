import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/prescription_model.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/prescription_provider.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_text_field_widget.dart';
import 'package:vaidraj/widgets/green_divider.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/loader.dart';
import 'package:collection/collection.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({
    super.key,
  });
  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  /// variables
  TextEditingController patientNameController = TextEditingController();
  TextEditingController otherMedicineController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var diseaseProvider =
        Provider.of<AllDiseaseProvider>(context, listen: false);
    if (diseaseProvider.diseasesModelForAppointment == null) {
      diseaseProvider.getAllDiseaseWithoutPagination(context: context);
    }
    var prescriptionProvider =
        Provider.of<PrescriptionStateProvider>(context, listen: false);
    prescriptionProvider.setSelectedDisease = "Depression";
    prescriptionProvider.setSelectedDiseaseId = 16;
    if (prescriptionProvider.productModel == null) {
      prescriptionProvider.getAllProducts(context: context);
    } else {
      print('product model has data');
    }
    if (prescriptionProvider.prescriptionModel.diseases?.isEmpty == true) {
      prescriptionProvider.prescriptionModel.diseases?.add(Diseases(
        diseaseName: prescriptionProvider.selectedDisease,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AllDiseaseProvider, PrescriptionStateProvider>(
      builder: (context, diseasesProvider, prescriptionProvider, child) =>
          SingleChildScrollView(
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
                      value: prescriptionProvider.selectedDisease,
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
                        prescriptionProvider.updateDisease(
                            disease: value as String,
                            diseaseId: diseasesProvider
                                    .diseasesModelForAppointment?.data?.data
                                    ?.where((e) => e.displayName == value)
                                    .first
                                    .id ??
                                0);
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select Disease !!";
                        }
                        return null;
                      },
                    ),
            ),
            if (!prescriptionProvider.isLoading ||
                prescriptionProvider.selectedDiseaseId != 0)
              PrescriptionWidget(),
            MethodHelper.heightBox(height: 2.h),
            paddingMethod(CustomTextFieldWidget(
                validator: (value) {},
                keyboardType: TextInputType.text,
                controller: otherMedicineController,
                decoration: MethodHelper.greenUnderLineBorder(
                    hintText: "Other Notes (if Any)"))),
            paddingMethod(CustomTextFieldWidget(
                validator: (value) {},
                keyboardType: TextInputType.text,
                controller: noteController,
                decoration: MethodHelper.greenUnderLineBorder(
                    hintText: "Add Note..."))),
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
  PrescriptionWidget({
    super.key,
  });

  @override
  State<PrescriptionWidget> createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  /// variable
  // Diseases? diseases;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// List of products (for illustration)
  @override
  Widget build(BuildContext context) {
    return Consumer<PrescriptionStateProvider>(
      builder: (context, prescriptionProvider, child) => prescriptionProvider
              .isLoading
          ? const Center(
              child: Loader(),
            )
          : CustomContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const CustomSearchBar(),
                    prescriptionProvider.productToShow.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) =>
                                GreenDividerLine(endIndent: 10.w, indent: 15.w),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                prescriptionProvider.productToShow.length,
                            itemBuilder: (context, index) {
                              Product? product =
                                  prescriptionProvider.productToShow[index];
                              final medicine = prescriptionProvider.diseaseList
                                  .firstWhereOrNull((e) =>
                                      e.diseaseName ==
                                      prescriptionProvider.selectedDisease)
                                  ?.medicine
                                  ?.firstWhereOrNull(
                                    (e) => e.productId == product.id,
                                  );
                              return PrescriptionPageWidget(
                                productId: product.id ?? 0,
                                productName: product.displayName ?? "-",
                                medicine: medicine,
                                onChanged: (value) {
                                  prescriptionProvider.updateMedicineSelection(
                                      isSelected: value ?? false,
                                      productId: product.id ?? 0);
                                },
                              );
                            })
                        : CustomContainer(
                            height: 20.h,
                            child: Center(
                                child: Text(
                              'No Data Found',
                              style: TextSizeHelper.smallHeaderStyle,
                            )),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}

// A common widget for the prescription item with checkboxes and selectable buttons
class PrescriptionPageWidget extends StatefulWidget {
  final int productId;
  final String productName;
  final Medicine? medicine;
  final void Function(bool?)? onChanged;
  PrescriptionPageWidget({
    required this.productId,
    required this.productName,
    required this.medicine,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _PrescriptionItemWidgetState createState() => _PrescriptionItemWidgetState();
}

class _PrescriptionItemWidgetState extends State<PrescriptionPageWidget> {
  // Default selections for time of day and when to take
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          _buildCheckboxRow(),
          if (widget.medicine?.isSelected ?? false) ...[
            _buildTimeOfDaySelector(),
            MethodHelper.heightBox(height: 1.h),
            _buildWhenToTakeSelector(medicine: widget.medicine),
          ]
        ],
      ),
    );
  }

  Widget _buildCheckboxRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
      child: Row(
        children: [
          Checkbox(
              activeColor: AppColors.greenColor,
              value: widget.medicine?.isSelected ?? false,
              onChanged: widget.onChanged),
          Expanded(
            child: Text(
              widget.productName,
              style: TextSizeHelper.smallTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDaySelector() {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Time of the Day'),
          MethodHelper.heightBox(height: 2.h),
          _buildTimeOfDayButtons(),
        ],
      ),
    );
  }

  Widget _buildTimeOfDayButtons() {
    return Consumer<PrescriptionStateProvider>(
      builder: (context, prescriptionProvider, child) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: AppSizes.size40),
          child: Row(
            children: ['Morning', 'AfterNoon', 'Evening', 'Night'].map((time) {
              return _buildSelectableButton(
                label: time,
                isSelected: widget.medicine?.time?.contains(time) ?? false,
                onTap: () {
                  prescriptionProvider.updateMedicineTime(
                      productId: widget.productId, dayTime: time);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWhenToTakeSelector({required Medicine? medicine}) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('When to Take'),
          MethodHelper.heightBox(height: 2.h),
          _buildWhenToTakeButtons(medicine: medicine),
        ],
      ),
    );
  }

  Widget _buildWhenToTakeButtons({required Medicine? medicine}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSizes.size40),
        child: Row(
          children: ['before meal', 'after meal'].map((when) {
            return _buildSelectableButton(
              label: when,
              isSelected: medicine?.toBeTaken == when,
              onTap: () {
                setState(() {
                  medicine?.toBeTaken = when;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.size40),
      child: Row(
        children: [
          Text(title, style: TextSizeHelper.xSmallHeaderStyle),
        ],
      ),
    );
  }

  Widget _buildSelectableButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        borderRadius: BorderRadius.circular(AppSizes.size20),
        borderWidth: 1,
        backGroundColor:
            isSelected ? AppColors.whiteColor : Colors.grey.shade300,
        borderColor: isSelected ? AppColors.greenColor : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size10,
          vertical: AppSizes.size10 - 5,
        ),
        child: Text(
          label,
          style: TextSizeHelper.xSmallHeaderStyle.copyWith(
            color: isSelected ? AppColors.greenColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
