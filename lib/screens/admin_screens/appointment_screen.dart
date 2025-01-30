import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  // List of products (for illustration)
  final List<Product> products = [
    Product(id: 1, name: 'Product 1'),
    Product(id: 2, name: 'Product 2'),
    Product(id: 3, name: 'Product 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return PrescriptionPageWidget(
            productId: product.id,
            productName: product.name,
            onChanged: (isChecked) {
              // Handle checkbox change if needed
              print(
                  '${product.name} is ${isChecked ? 'checked' : 'unchecked'}');
            },
          );
        });
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
          Row(
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
              Text(
                widget.productName,
                style: TextSizeHelper.smallHeaderStyle,
              ),
            ],
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
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: ['before meal', 'after meal'].map((when) {
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //         child: ChoiceChip(
                  //           label: Text(when),
                  //           selected: selectedWhenToTake == when,
                  //           onSelected: (selected) {
                  //             setState(() {
                  //               selectedWhenToTake = selected ? when : '';
                  //             });
                  //           },
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String name;

  Product({required this.id, required this.name});
}
