import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/services/contact_service/feedback_service.dart';
import 'package:vaidraj/utils/border_helper/border_helper.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_dropdown.dart';
import 'package:vaidraj/widgets/custom_text_field_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../constants/color.dart';
import '../../constants/text_size.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _selectedSentimentIndex = -1; // No sentiment selected initially
  TextEditingController reasonController = TextEditingController();
  String selectedValue = "";
  bool isDropdownOpen = false;
  FeedbackService service = FeedbackService();
  // Function to handle the selection of a sentiment
  void _selectSentiment(int index) {
    setState(() {
      _selectedSentimentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            langProvider.translate("feedback"),
            style: TextSizeHelper.mediumTextStyle
                .copyWith(color: AppColors.brownColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: CustomContainer(
                    width: 80.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MethodHelper.heightBox(height: 2.h),
                        Text(
                          langProvider.translate('howYourExperienceWithUs'),
                          style: TextSizeHelper.smallHeaderStyle
                              .copyWith(color: AppColors.brownColor),
                        ),
                        MethodHelper.heightBox(height: 2.h),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(5, (index) {
                              IconData icon;
                              Color color;
                              switch (index) {
                                case 0:
                                  icon = Icons
                                      .sentiment_very_dissatisfied_outlined;
                                  color = _selectedSentimentIndex == index
                                      ? Colors.red
                                      : Colors.grey;
                                  break;
                                case 1:
                                  icon = Icons.sentiment_dissatisfied_outlined;
                                  color = _selectedSentimentIndex == index
                                      ? Colors.orange
                                      : Colors.grey;
                                  break;
                                case 2:
                                  icon = Icons.sentiment_neutral_outlined;
                                  color = _selectedSentimentIndex == index
                                      ? Colors.yellow
                                      : Colors.grey;
                                  break;
                                case 3:
                                  icon = Icons.sentiment_satisfied_outlined;
                                  color = _selectedSentimentIndex == index
                                      ? Colors.blue
                                      : Colors.grey;
                                  break;
                                case 4:
                                  icon =
                                      Icons.sentiment_very_satisfied_outlined;
                                  color = _selectedSentimentIndex == index
                                      ? Colors.green
                                      : Colors.grey;
                                  break;
                                default:
                                  icon = Icons
                                      .sentiment_very_dissatisfied_outlined;
                                  color = Colors.grey;
                              }
                              return GestureDetector(
                                  onTap: () => _selectSentiment(index),
                                  child: Icon(
                                    icon,
                                    color: color,
                                    size: AppSizes.size30,
                                  ));
                            })),
                        MethodHelper.heightBox(height: 3.h),
                        Row(
                          children: [
                            Text(
                              langProvider.translate('anythingYouWantToTellUs'),
                              style: TextSizeHelper.smallHeaderStyle,
                            ),
                          ],
                        ),
                        MethodHelper.heightBox(height: 1.h),
                        CustomDropDownWidget(
                          prefixIcon: Icons.question_answer,
                          decoration: BorderHelper.brownAllBorder.copyWith(
                            suffixIcon: Icon(
                              isDropdownOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                          ),
                          hintText: "",
                          items: [
                            DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  isDropdownOpen = !isDropdownOpen;
                                });
                              },
                              child: Text('Other'),
                              value: "value",
                            )
                          ],
                          onChanged: (value) => {
                            setState(() {
                              selectedValue = value as String;
                            })
                          },
                        ),
                        MethodHelper.heightBox(height: 2.h),
                        CustomContainer(
                          backGroundColor: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.19),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: Offset(
                                0,
                                10,
                              ),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.23),
                              blurRadius: 6,
                              spreadRadius: 0,
                              offset: Offset(
                                0,
                                6,
                              ),
                            ),
                          ],
                          child: Column(
                            children: [
                              CustomContainer(
                                padding: const EdgeInsets.all(AppSizes.size10),
                                child: CustomTextFieldWidget(
                                    validator: (value) {},
                                    minLines: 5,
                                    keyboardType: TextInputType.text,
                                    style: TextSizeHelper.smallTextStyle,
                                    controller: reasonController,
                                    decoration: BorderHelper.inputBorder
                                        .copyWith(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: langProvider
                                                .translate('comment'))),
                              ),
                              CustomContainer(
                                height: 5,
                                backGroundColor: AppColors.greenColor,
                              )
                            ],
                          ),
                        ),
                        MethodHelper.heightBox(height: 10.h),
                        CustomContainer(
                          width: 25.w,
                          child: PrimaryBtn(
                              btnText: langProvider.translate('submit'),
                              onTap: () async {
                                if (_selectedSentimentIndex == -1 &&
                                    selectedValue == "" &&
                                    reasonController.text.isEmpty) {
                                  WidgetHelper.customSnackBar(
                                      context: context,
                                      isError: true,
                                      title: langProvider
                                          .translate('provideAction'));
                                } else {
                                  await service
                                      .feedback(
                                          context: context,
                                          title: selectedValue,
                                          description: reasonController.text,
                                          rating: (_selectedSentimentIndex + 1)
                                              .toString())
                                      .then((success) => success
                                          ? WidgetHelper.customSnackBar(
                                              context: context,
                                              title: langProvider
                                                  .translate('messageSent'))
                                          : WidgetHelper.customSnackBar(
                                              context: context,
                                              title: "Somthing Went Wrong",
                                              isError: true));
                                }
                              }),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
