import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/mobile_verification_provider.dart';
import 'package:vaidraj/screens/patient_screen/get_in_touch.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_text_field_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';

import '../../constants/color.dart';
import '../../constants/text_size.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key, this.fromPage = false});
  final bool fromPage;
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  // variables
  String selectedDate = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
  DateTime? dob;
  bool isForOther = false;
  List<String> slots = ['Morning Slot', "Evening Slot"];
  //// appointment data
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController appointmentDateController = TextEditingController();
  String? slotToBook;
  int? diseaseId;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appointmentDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    slotToBook = slots[0];
    initControllers();
  }

  Future<void> initControllers() async {
    nameController.text = await SharedPrefs.getName();
    emailController.text = await SharedPrefs.getEmail();
    contactController.text = await SharedPrefs.getMobileNumber();
    dobController.text = await SharedPrefs.getDOB();
    addressController.text = await SharedPrefs.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocalizationProvider, MobileVerificationProvider>(
      builder: (context, langProvider, mobileVerProvider, child) => Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: widget.fromPage
            ? AppBar(
                backgroundColor: AppColors.whiteColor,
                title: Text(
                  langProvider.translate("appointment"),
                  style: TextSizeHelper.mediumTextStyle
                      .copyWith(color: AppColors.brownColor),
                ),
              )
            : PreferredSize(
                preferredSize:
                    Size.fromHeight(0), // This effectively removes the AppBar
                child: Container(), // Empty container when no AppBar is needed
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              LogoWithInfoContainer(children: [
                Text(
                  langProvider.translate("maharshi"),
                  style: TextSizeHelper.xSmallTextStyle,
                ),
                MethodHelper.heightBox(height: 3.h),
                Row(
                  children: [
                    PrimaryBtn(
                      btnText: langProvider.translate("sendEmail"),
                      onTap: () {
                        // add logic to email
                      },
                      height: 3.h,
                      width: 25.w,
                      borderRadius: BorderRadius.circular(5),
                      backGroundColor: AppColors.whiteColor,
                      borderColor: AppColors.brownColor,
                      textStyle: TextSizeHelper.xSmallTextStyle
                          .copyWith(color: AppColors.brownColor),
                    ),
                    MethodHelper.widthBox(width: 2.w),
                    PrimaryBtn(
                      btnText: langProvider.translate("call"),
                      onTap: () {
                        // add logic to call
                      },
                      height: 3.h,
                      width: 25.w,
                      borderRadius: BorderRadius.circular(5),
                      borderColor: AppColors.brownColor,
                      textStyle: TextSizeHelper.xSmallTextStyle
                          .copyWith(color: AppColors.whiteColor),
                    )
                  ],
                )
              ]),
              MethodHelper.heightBox(height: AppSizes.size10),
              CustomContainer(
                height: 5.h,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size10),
                  separatorBuilder: (context, index) =>
                      MethodHelper.widthBox(width: 2.w),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 365,
                  itemBuilder: (context, index) {
                    String date = DateFormat('EEE, dd MMM yyy')
                        .format(DateTime.now().add(Duration(days: index)));
                    return ToggleBtn(
                      isSelected: date == selectedDate,
                      text: date,
                      onTap: () => setState(() {
                        selectedDate = date;
                        // this will update text in appointment date field upon click
                        appointmentDateController.text =
                            DateFormat('yyyy-MM-dd').format(
                                DateTime.now().add(Duration(days: index)));
                      }),
                    );
                  },
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              //// check box to indicate appointment for other
              Row(
                children: [
                  Checkbox(
                    value: isForOther,
                    activeColor: AppColors.greenColor,
                    onChanged: (value) => setState(() {
                      isForOther = !isForOther;
                    }),
                  ),
                  Text(
                    langProvider.translate('forOther'),
                    style: TextSizeHelper.smallTextStyle,
                  )
                ],
              ),
              MethodHelper.heightBox(height: 2.h),
              paddingMethod(
                CustomTextFieldWidget(
                  decoration: MethodHelper.greenUnderLineBorder(
                    hintText: langProvider.translate("name"),
                  ),
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return langProvider.translate("nameReq");
                    }
                    return null;
                  },
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              paddingMethod(
                CustomTextFieldWidget(
                  decoration: MethodHelper.greenUnderLineBorder(
                    hintText: langProvider.translate("email"),
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 40,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return langProvider.translate("email");
                    } else {
                      if (!RegExp(
                              r'^(?!.*[<>\";])([a-zA-Z0-9._%+-]+)@[a-zA-Z.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value ?? "")) {
                        return langProvider.translate("emailNotValid");
                      }
                      ;
                    }
                    return null;
                  },
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              paddingMethod(
                CustomTextFieldWidget(
                  decoration: MethodHelper.greenUnderLineBorder(
                    hintText: langProvider.translate("contactNumber"),
                  ),
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return langProvider.translate("numberReq");
                    }
                    if (value?.contains(RegExp(r"[ ,-.]")) ?? true) {
                      return langProvider.translate("mobileNotValid");
                    }
                    return null;
                  },
                ),
              ),
              MethodHelper.heightBox(height: 2.h),

              /// date of birth field
              paddingMethod(
                GestureDetector(
                  onTap: () async {
                    dob = await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (dob != null) {
                      dobController.text =
                          DateFormat('yyyy-MM-dd').format(dob!);
                    }
                  },
                  child: CustomTextFieldWidget(
                    enabled: false,
                    decoration: MethodHelper.greenUnderLineBorder(
                        hintText: langProvider.translate("dateOfBirth"),
                        suffix: const Icon(
                          Icons.date_range,
                          color: AppColors.greenColor,
                        )),
                    controller: appointmentDateController,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return langProvider.translate("dateOfBirthReq");
                      }
                      return null;
                    },
                  ),
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              paddingMethod(
                CustomTextFieldWidget(
                  decoration: MethodHelper.greenUnderLineBorder(
                    hintText: langProvider.translate("address"),
                  ),
                  controller: addressController,
                  minLines: 2,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return langProvider.translate("addressReq");
                    }
                    return null;
                  },
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              paddingMethod(
                GestureDetector(
                  onTap: () async {
                    dob = await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (dob != null) {
                      dobController.text =
                          DateFormat('yyyy-MM-dd').format(dob!);
                      setState(() {
                        selectedDate =
                            DateFormat('EEE, dd MMM yyy').format(dob!);
                      });
                    }
                  },
                  child: CustomTextFieldWidget(
                    enabled: false,
                    decoration: MethodHelper.greenUnderLineBorder(
                        hintText: langProvider.translate("appointmentDate"),
                        suffix: const Icon(
                          Icons.date_range,
                          color: AppColors.greenColor,
                        )),
                    controller: appointmentDateController,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return langProvider.translate("appointmentDateReq");
                      }
                      return null;
                    },
                  ),
                ),
              ),
              MethodHelper.heightBox(height: 2.h),
              CustomContainer(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: AppSizes.size10),
                height: 5.h,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size10),
                  separatorBuilder: (context, index) =>
                      MethodHelper.widthBox(width: 2.w),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    return ToggleBtn(
                      isSelected: slots[index] == slotToBook,
                      text: slots[index],
                      onTap: () => setState(() {
                        slotToBook = slots[index];
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding paddingMethod(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
        child: child,
      );
}

class ToggleBtn extends StatefulWidget {
  ToggleBtn(
      {super.key,
      required this.isSelected,
      this.height,
      this.width,
      required this.text,
      required this.onTap});
  bool isSelected;
  final double? height;
  final double? width;
  final String text;
  final VoidCallback onTap;
  @override
  State<ToggleBtn> createState() => _ToggleBtnState();
}

class _ToggleBtnState extends State<ToggleBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: CustomContainer(
        backGroundColor:
            widget.isSelected ? AppColors.brownColor : AppColors.whiteColor,
        borderColor: AppColors.brownColor,
        borderRadius: BorderRadius.circular(5),
        height: widget.height ?? 4.h,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Text(
          widget.text,
          style: TextSizeHelper.xSmallTextStyle.copyWith(
              color: widget.isSelected
                  ? AppColors.whiteColor
                  : AppColors.brownColor),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
