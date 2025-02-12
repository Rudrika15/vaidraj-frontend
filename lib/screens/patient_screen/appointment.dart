import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/appointment_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/patient_screen/get_in_touch.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_text_field_widget.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../constants/color.dart';
import '../../constants/text_size.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../widgets/custom_dropdown.dart';
import '../home/home_screen.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key, this.fromPage = false, this.diseaseId});
  final bool fromPage;
  final int? diseaseId;
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> with NavigateHelper {
  // variables
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedDate = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
  DateTime? dob;
  bool isForOther = false;
  List<String> slots = ['Morning', "Evening"];
  //// appointment data
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController appointmentDateController = TextEditingController();
  String slotToBook = "morning";
  int? diseaseId;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.diseaseId != null) {
      diseaseId = widget.diseaseId;
    }
    appointmentDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    slotToBook = slots[0];
    initControllers();
    var diseaseProvider =
        Provider.of<AllDiseaseProvider>(context, listen: false);
    if (diseaseProvider.diseasesModelForAppointment == null) {
      diseaseProvider.getAllDiseaseWithoutPagination(context: context);
    }
  }

  Future<void> initControllers() async {
    nameController.text = await SharedPrefs.getName();
    emailController.text = await SharedPrefs.getEmail();
    contactController.text = await SharedPrefs.getMobileNumber();
    dobController.text = await SharedPrefs.getDOB();
    addressController.text = await SharedPrefs.getAddress();
  }

  Future<void> emptyController() async {
    nameController.text = "";
    emailController.text = "";
    contactController.text = "";
    dobController.text = "";
    dob = null;
    addressController.text = "";
    diseaseId = null;
    subjectController.text = "";
    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // will send user to my property page on back btn press
      canPop: widget.fromPage ? true : false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        String role = await SharedPrefs.getRole();
        if (!widget.fromPage) {
          pushRemoveUntil(
              context,
              HomeScreen(
                isAdmin: role == "admin",
                isDoctor: role == "doctor",
                screenIndex: 0,
              ));
        }
      },
      child: Consumer3<LocalizationProvider, AllDiseaseProvider,
          AppointmentProvider>(
        builder: (context, langProvider, diseasesProvider, appointmentProvider,
                child) =>
            Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: widget.fromPage
              ? AppBar(
                  backgroundColor: AppColors.whiteColor,
                  surfaceTintColor: AppColors.whiteColor,
                  title: Text(
                    langProvider.translate("appointment"),
                    style: TextSizeHelper.mediumTextStyle
                        .copyWith(color: AppColors.brownColor),
                  ),
                )
              : PreferredSize(
                  preferredSize:
                      Size.fromHeight(0), // This effectively removes the AppBar
                  child:
                      Container(), // Empty container when no AppBar is needed
                ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Form(
              key: formKey,
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
                            pushRemoveUntil(
                                context,
                                HomeScreen(
                                  isDoctor: false,
                                  isAdmin: false,
                                  screenIndex: 7,
                                ));
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
                            MethodHelper.dialNumber(AppStrings.mobile);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size10),
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
                          if (isForOther == true) {
                            isForOther = false;
                            initControllers();
                          } else {
                            isForOther = true;
                            emptyController();
                          }
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
                        /// for birth date
                        /// if making appointment for other than and only can select birthdate
                        if (isForOther) {
                          dob = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1960),
                              lastDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ));
                          if (dob != null) {
                            dobController.text =
                                DateFormat('yyyy-MM-dd').format(dob!);
                          }
                        } else {
                          WidgetHelper.customSnackBar(
                              context: context,
                              title: "Only Available If Appoint is For Other!!",
                              isError: true);
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
                        controller: dobController,
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
                      //// for appointment date
                      onTap: () async {
                        dob = await showDatePicker(
                            context: context,
                            firstDate: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                            lastDate: DateTime(
                              DateTime.now().year + 1,
                              DateTime.now().month,
                              DateTime.now().day,
                            ));
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size10),
                      separatorBuilder: (context, index) =>
                          MethodHelper.widthBox(width: 2.w),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: slots.length,
                      itemBuilder: (context, index) {
                        return ToggleBtn(
                          isSelected: slotToBook.toLowerCase() ==
                              slots[index].toLowerCase(),
                          text: slots[index] + " Slot",
                          onTap: () => setState(() {
                            slotToBook = slots[index].toLowerCase();
                          }),
                        );
                      },
                    ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  paddingMethod(
                    diseasesProvider.isLoading
                        ? const Center(
                            child: Loader(),
                          )
                        : CustomDropDownWidget(
                            value: !widget.fromPage
                                ? null
                                : diseaseId != null
                                    ? diseaseId
                                    : null,
                            alignment: Alignment.centerLeft,
                            prefixIcon: Icons.storefront_outlined,
                            decoration: MethodHelper.greenUnderLineBorder(
                                hintText: langProvider.translate("disease")),
                            items: diseasesProvider.diseasesModelForAppointment
                                        ?.data?.data?.isNotEmpty ==
                                    true
                                ? List<DropdownMenuItem<Object?>>.generate(
                                    diseasesProvider.diseasesModelForAppointment
                                            ?.data?.data?.length ??
                                        0,
                                    (index) {
                                      return DropdownMenuItem(
                                        value: diseasesProvider
                                            .diseasesModelForAppointment
                                            ?.data
                                            ?.data?[index]
                                            .id,
                                        child: Text(
                                          diseasesProvider
                                                  .diseasesModelForAppointment
                                                  ?.data
                                                  ?.data?[index]
                                                  .displayName ??
                                              "-",
                                          style:
                                              TextSizeHelper.smallHeaderStyle,
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
                              setState(() {
                                diseaseId = value as int;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return langProvider.translate("diseaseReq");
                              }
                              return null;
                            },
                          ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  paddingMethod(
                    CustomTextFieldWidget(
                      decoration: MethodHelper.greenUnderLineBorder(
                        hintText: langProvider.translate("subject"),
                      ),
                      controller: subjectController,
                      keyboardType: TextInputType.text,
                      validator: (value) => null,
                      // validator: (value) {
                      //   if (value?.isEmpty == true) {
                      //     return langProvider.translate("subjectReq");
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  paddingMethod(
                    CustomTextFieldWidget(
                      decoration: MethodHelper.greenUnderLineBorder(
                        hintText: langProvider.translate("message"),
                      ),
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      validator: (value) => null,
                      // validator: (value) {
                      //   if (value?.isEmpty == true) {
                      //     return langProvider.translate("messageReq");
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  MethodHelper.heightBox(height: 2.h),
                  SizedBox(
                    width: 25.w,
                    child: appointmentProvider.isLoading
                        ? const Center(
                            child: Loader(),
                          )
                        : PrimaryBtn(
                            btnText: langProvider.translate('submit'),
                            onTap: () async {
                              if (formKey.currentState!.validate() &&
                                  slotToBook != "") {
                                await appointmentProvider
                                    .createAppointment(
                                        userId: int.parse(
                                            await SharedPrefs.getId()),
                                        name: nameController.text,
                                        email: emailController.text,
                                        contactNumber: contactController.text,
                                        dob: dobController.text,
                                        address: addressController.text,
                                        appointmentDate:
                                            appointmentDateController.text,
                                        diseaseId: diseaseId ?? 0,
                                        message: messageController.text,
                                        slot: slotToBook,
                                        subject: subjectController.text,
                                        context: context)
                                    .then((success) {
                                  if (success) {
                                    emptyController();
                                  } else {
                                    WidgetHelper.customSnackBar(
                                        context: context,
                                        title: "Somthing went Wrong",
                                        isError: true);
                                  }
                                });

                                // print(
                                //     "Name => ${nameController.text} and type ${nameController.text.runtimeType}");
                                // print(
                                //     "email => ${emailController.text} and type ${emailController.text.runtimeType}");
                                // print(
                                //     "contactNumber => ${contactController.text} and type ${contactController.text.runtimeType}");
                                // print(
                                //     "DOB => ${dobController.text} and type ${dobController.text.runtimeType}");
                                // print(
                                //     "address => ${addressController.text} and type ${addressController.text.runtimeType}");
                                // print(
                                //     "appointmentdate => ${appointmentDateController.text} and type ${appointmentDateController.text.runtimeType}");
                                // print(
                                //     "slot => $slotToBook and type ${slotToBook.runtimeType}");
                                // print(
                                //     "disease => $diseaseId and type ${diseaseId.runtimeType}");
                                // print(
                                //     "subject => ${subjectController.text} and type ${subjectController.text.runtimeType}");
                                // print(
                                //     "message => ${messageController.text} and type ${messageController.text.runtimeType}");
                              } else {
                                print("Appointment Not verified");
                              }
                            }),
                  )
                ],
              ),
            ),
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
