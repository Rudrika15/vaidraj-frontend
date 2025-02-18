import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/provider/add_new_patient_provider.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/mobile_verification_provider.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_dropdown.dart';
import 'package:vaidraj/widgets/green_divider.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'dart:math' as math;
import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../constants/strings.dart';
import '../../constants/text_size.dart';
import '../../utils/method_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/primary_btn.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({super.key, required this.UserStatus, this.phoneNumber});
  final String UserStatus;
  final String? phoneNumber;
  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> with NavigateHelper {
  //
  GlobalKey<FormState> newForm = GlobalKey<FormState>();
  GlobalKey<FormState> patientForm = GlobalKey<FormState>();
  GlobalKey<FormState> staffForm = GlobalKey<FormState>();
  // for doctor
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  // for patient

  // for new user
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? dob;
  int branchSelection = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.phoneNumber != null) {
      numberController.text = widget.phoneNumber ?? "";
    }
    var getBranch = Provider.of<GetBrachProvider>(context, listen: false);
    getBranch.getBranch(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<LocalizationProvider, GetBrachProvider,
        AddNewPatientProvider, MobileVerificationProvider>(
      builder: (context, langProvider, branchProvider, patientProvider,
              mobileVerProvider, child) =>
          Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
              top: 30.h,
              right: -5.w,
              child: Opacity(
                opacity: 0.2,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: const Image(
                    image: AssetImage(AppStrings.logoHerb),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60.h,
              left: -5.w,
              child: const Opacity(
                opacity: 0.2,
                child: Image(
                  image: AssetImage(AppStrings.logoHerb),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            ListView(
              children: [
                CustomContainer(
                  width: 100.w,
                  height: 20.h,
                  image: const DecorationImage(
                      image: AssetImage(AppStrings.image3),
                      fit: BoxFit.contain),
                ),
                MethodHelper.heightBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        widget.UserStatus == "STAFF" ||
                                widget.UserStatus == "ADMIN"
                            ? langProvider.translate("Welcome")
                            : widget.UserStatus == "PATIENT"
                                ? langProvider.translate("welcomeBack")
                                : langProvider.translate("registration"),
                        style: TextSizeHelper.xLargeHeaderStyle
                            .copyWith(color: AppColors.brownColor))
                  ],
                ),
                GreenDividerLine(
                    endIndent: 50.w,
                    indent: widget.UserStatus == "PATIENT"
                        ? 25.w
                        : widget.UserStatus == "NEW"
                            ? 28.w
                            : 32.w),
                MethodHelper.heightBox(height: 5.h),
                widget.UserStatus == "STAFF" || widget.UserStatus == "ADMIN"
                    ?

                    /// login staff member
                    Form(
                        key: staffForm,
                        child: CustomContainer(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  obscureText: showPassword,
                                  controller: passwordController,
                                  decoration: MethodHelper.brownUnderLineBorder(
                                      suffix: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          icon: showPassword
                                              ? const Icon(
                                                  Icons.visibility_off,
                                                  color: AppColors.brownColor,
                                                )
                                              : const Icon(
                                                  Icons.visibility,
                                                  color: AppColors.brownColor,
                                                )),
                                      hintText:
                                          langProvider.translate("password"),
                                      prefixIcon: Icons.password),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return;
                                    }
                                    return null;
                                  },
                                ),
                                MethodHelper.heightBox(height: 2.h),
                                // GestureDetector(
                                //   onTap: () {
                                //     // add logic for forgot password
                                //   },
                                //   child: Text(
                                //     langProvider.translate("forgotPass"),
                                //     style: TextSizeHelper.smallTextStyle,
                                //   ),
                                // )
                              ],
                            )))
                    : widget.UserStatus == "PATIENT"
                        ?

                        /// login exiting patient
                        Form(
                            key: patientForm,
                            child: CustomContainer(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: GestureDetector(
                                onTap: () async {
                                  dob = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1950),
                                      lastDate:
                                          DateTime(DateTime.now().year + 1));
                                  if (dob != null) {
                                    dobController.text =
                                        DateFormat('yyyy-MM-dd').format(dob!);
                                  }
                                },
                                child: CustomTextFieldWidget(
                                    enabled: false,
                                    decoration:
                                        MethodHelper.brownUnderLineBorder(
                                            hintText: langProvider
                                                .translate("dateOfBirth"),
                                            prefixIcon: Icons.cake_outlined),
                                    suffix: IconButton(
                                        onPressed: () async {
                                          dob = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 1));
                                          if (dob != null) {
                                            dobController.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(dob!);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.date_range_outlined,
                                          color: AppColors.greenColor,
                                        )),
                                    validator: (value) {
                                      if (value?.isEmpty == true) {
                                        return langProvider
                                            .translate("dateOfBirthReq");
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.none,
                                    controller: dobController),
                              ),
                            ))
                        :

                        /// register new user
                        Form(
                            key: newForm,
                            child: CustomContainer(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  children: [
                                    CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.brownUnderLineBorder(
                                              hintText: langProvider
                                                  .translate("name"),
                                              prefixIcon:
                                                  Icons.person_outline_sharp),
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      maxLength: 30,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate("nameReq");
                                        }
                                        return null;
                                      },
                                    ),
                                    MethodHelper.heightBox(height: 1.h),
                                    CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.brownUnderLineBorder(
                                              hintText: langProvider
                                                  .translate("contactNumber"),
                                              prefixIcon: Icons.phone),
                                      controller: numberController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate("numberReq");
                                        }
                                        if (value
                                                ?.contains(RegExp(r"[ ,-.]")) ??
                                            true) {
                                          return langProvider
                                              .translate("mobileNotValid");
                                        }
                                        return null;
                                      },
                                    ),
                                    MethodHelper.heightBox(height: 1.h),
                                    CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.brownUnderLineBorder(
                                              hintText: langProvider
                                                  .translate("email"),
                                              prefixIcon: Icons.email_outlined),
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLength: 40,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate("email");
                                        } else {
                                          if (!RegExp(
                                                  r'^(?!.*[<>\";])([a-zA-Z0-9._%+-]+)@[a-zA-Z.-]+\.[a-zA-Z]{2,}$')
                                              .hasMatch(value ?? "")) {
                                            return langProvider
                                                .translate("emailNotValid");
                                          }
                                          ;
                                        }
                                        return null;
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        dob = await showDatePicker(
                                            keyboardType:
                                                TextInputType.datetime,
                                            context: context,
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day));
                                        if (dob != null) {
                                          dobController.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(dob!);
                                        }
                                      },
                                      child: CustomTextFieldWidget(
                                          enabled: false,
                                          decoration:
                                              MethodHelper.brownUnderLineBorder(
                                                  hintText: langProvider
                                                      .translate("dateOfBirth"),
                                                  prefixIcon:
                                                      Icons.cake_outlined),
                                          suffix: const Icon(
                                            Icons.date_range_outlined,
                                            color: AppColors.greenColor,
                                          ),
                                          validator: (value) {
                                            if (value?.isEmpty == true) {
                                              return langProvider
                                                  .translate("dateOfBirthReq");
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.none,
                                          controller: dobController),
                                    ),
                                    MethodHelper.heightBox(height: 1.h),
                                    branchProvider.isLoading
                                        ? const Center(child: Loader())
                                        : CustomDropDownWidget(
                                            alignment: Alignment.centerLeft,
                                            hintText: langProvider
                                                .translate("selectBranch"),
                                            prefixIcon:
                                                Icons.storefront_outlined,
                                            suffixIcon:
                                                Icons.keyboard_arrow_down,
                                            items: branchProvider.getBranchModel
                                                        ?.data?.isNotEmpty ==
                                                    true
                                                ? List<
                                                    DropdownMenuItem<
                                                        Object?>>.generate(
                                                    branchProvider
                                                            .getBranchModel
                                                            ?.data
                                                            ?.length ??
                                                        0,
                                                    (index) {
                                                      return DropdownMenuItem(
                                                        value: branchProvider
                                                            .getBranchModel
                                                            ?.data?[index]
                                                            .id,
                                                        child: Text(
                                                          branchProvider
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
                                                      child: Text(
                                                        "No Branch Found",
                                                        style: TextSizeHelper
                                                            .smallHeaderStyle,
                                                      ),
                                                    )
                                                  ],
                                            onChanged: (value) {
                                              setState(() {
                                                branchSelection = value as int;
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return langProvider
                                                    .translate("branchReq");
                                              }
                                              return null;
                                            },
                                          ),
                                    MethodHelper.heightBox(height: 1.h),
                                    CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.brownUnderLineBorder(
                                              hintText: langProvider
                                                  .translate("address"),
                                              prefixIcon:
                                                  Icons.location_on_outlined),
                                      controller: addressController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate("addressReq");
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ))),
              ],
            )
          ],
        )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size20, vertical: AppSizes.size10),
          child: CustomContainer(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: patientProvider.isLoading ||
                      mobileVerProvider.isLoading ||
                      branchProvider.isLoading
                  ? CustomContainer(
                      child: Center(child: Loader()),
                    )
                  : PrimaryBtn(
                      btnText: widget.UserStatus == "STAFF" ||
                              widget.UserStatus == "ADMIN"
                          ? langProvider.translate("login")
                          : langProvider.translate("submit"),
                      onTap: () async {
                        if (widget.UserStatus == "STAFF") {
                          if (staffForm.currentState!.validate()) {
                            await mobileVerProvider.verifyPassword(
                                context: context,
                                mobile: mobileVerProvider
                                        .verifyMobileNumberModel
                                        ?.data
                                        ?.mobileNo ??
                                    "",
                                password: passwordController.text);
                            if (mobileVerProvider.isPasswordVerified) {
                              pushRemoveUntil(
                                  context,
                                  HomeScreen(
                                    isDoctor: true,
                                    isAdmin: false,
                                  ));
                              WidgetHelper.customSnackBar(
                                  context: context, title: "Welcome");
                              print("staff validated");
                              return;
                            }
                          }
                        } else if (widget.UserStatus == "ADMIN") {
                          if (staffForm.currentState!.validate()) {
                            await mobileVerProvider.verifyPassword(
                                context: context,
                                mobile: mobileVerProvider
                                        .verifyMobileNumberModel
                                        ?.data
                                        ?.mobileNo ??
                                    "",
                                password: passwordController.text);
                            if (mobileVerProvider.isPasswordVerified) {
                              pushRemoveUntil(
                                  context,
                                  HomeScreen(
                                    isDoctor: false,
                                    isAdmin: true,
                                  ));
                              WidgetHelper.customSnackBar(
                                  context: context, title: "Welcome");
                              print("staff validated");
                              return;
                            }
                          }
                        } else if (widget.UserStatus == "PATIENT") {
                          if (patientForm.currentState!.validate()) {
                            if (dobController.text ==
                                mobileVerProvider
                                    .verifyMobileNumberModel?.data?.dob) {
                              SharedPrefs.saveToken(mobileVerProvider
                                      .verifyMobileNumberModel?.token ??
                                  "");
                              SharedPrefs.saveRole(mobileVerProvider
                                      .verifyMobileNumberModel?.data?.role ??
                                  "");
                              WidgetHelper.customSnackBar(
                                context: context,
                                title: "Welcome",
                              );
                              pushRemoveUntil(
                                  context,
                                  HomeScreen(
                                    isDoctor: false,
                                    isAdmin: false,
                                  ));
                              print("patient validated");
                              return;
                            } else {
                              WidgetHelper.customSnackBar(
                                  context: context,
                                  title: "Incorrect Date !!",
                                  isError: true);
                              dobController.text = "";
                              return;
                            }
                          }
                        } else {
                          // if new user than do this
                          if (newForm.currentState!.validate()) {
                            await patientProvider.addPatient(
                                context: context,
                                branchId: branchSelection,
                                name: nameController.text,
                                email: emailController.text,
                                mobile: numberController.text,
                                password: "123456",
                                address: addressController.text,
                                birthDate: dobController.text);
                            if (patientProvider.patientModel?.success == true) {
                              WidgetHelper.customSnackBar(
                                  context: context,
                                  title: "User Account Created");
                              pushRemoveUntil(
                                  context,
                                  const HomeScreen(
                                    isDoctor: false,
                                    isAdmin: false,
                                  ));
                            }
                          }
                        }
                      })),
        ),
      ),
    );
  }
}
