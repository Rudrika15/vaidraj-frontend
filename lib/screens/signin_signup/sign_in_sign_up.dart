import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_dropdown.dart';
import 'package:vaidraj/widgets/green_divider.dart';
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
  const SignInSignUp({super.key, required this.UserStatus});
  final String UserStatus;
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
  String branchSelection = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    image: AssetImage(AppStrings.image3), fit: BoxFit.contain),
              ),
              MethodHelper.heightBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      widget.UserStatus == "STAFF"
                          ? "Welcome Back Doctor"
                          : widget.UserStatus == "PATIENT"
                              ? "Welcome Back"
                              : "Registration",
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
                          : 16.w),
              MethodHelper.heightBox(height: 5.h),
              widget.UserStatus == "STAFF"
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
                                hintText: "Password",
                                obscureText: showPassword,
                                controller: passwordController,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                prefixIcon: Icons.password,
                                suffixIcon: null,
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: showPassword
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: AppColors.greenColor,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            color: AppColors.errorColor,
                                          )),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Password required";
                                  }
                                  return null;
                                },
                              ),
                              MethodHelper.heightBox(height: 2.h),
                              GestureDetector(
                                onTap: () {
                                  // add logic for forgot password
                                },
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextSizeHelper.smallTextStyle,
                                ),
                              )
                            ],
                          )))
                  : widget.UserStatus == "PATIENT"
                      ?

                      /// login exiting patient
                      Form(
                          key: patientForm,
                          child: CustomContainer(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: CustomTextFieldWidget(
                                hintText: "Date Of Birth",
                                prefixIcon: Icons.cake_outlined,
                                suffix: IconButton(
                                    onPressed: () async {
                                      dob = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(
                                              DateTime.now().year - 18));
                                      if (dob != null) {
                                        dobController.text =
                                            DateFormat.yMd().format(dob!);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.date_range_outlined,
                                      color: AppColors.greenColor,
                                    )),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return "Birth Date Required";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.none,
                                controller: dobController),
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
                                    hintText: "Name",
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    maxLength: 30,
                                    prefixIcon: Icons.person_outline_sharp,
                                    validator: (value) {
                                      if (value?.isEmpty == true) {
                                        return "Name Required";
                                      }
                                      return null;
                                    },
                                  ),
                                  MethodHelper.heightBox(height: 1.h),
                                  CustomTextFieldWidget(
                                    hintText: "Contact Number",
                                    controller: numberController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    prefixIcon: Icons.phone,
                                    validator: (value) {
                                      if (value?.isEmpty == true) {
                                        return "Number Required";
                                      }
                                      return null;
                                    },
                                  ),
                                  MethodHelper.heightBox(height: 1.h),
                                  CustomTextFieldWidget(
                                    hintText: "Email",
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 40,
                                    prefixIcon: Icons.email_outlined,
                                    validator: (value) {
                                      if (value?.isEmpty == true) {
                                        return "Email Required";
                                      } else {
                                        if (!RegExp(
                                                r'^(?!.*[<>\";])([a-zA-Z0-9._%+-]+)@[a-zA-Z.-]+\.[a-zA-Z]{2,}$')
                                            .hasMatch(value ?? "")) {
                                          return "Email is not valid";
                                        }
                                        ;
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomTextFieldWidget(
                                      hintText: "Date Of Birth",
                                      prefixIcon: Icons.cake_outlined,
                                      suffix: IconButton(
                                          onPressed: () async {
                                            dob = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(
                                                    DateTime.now().year - 18));
                                            if (dob != null) {
                                              dobController.text =
                                                  DateFormat.yMd().format(dob!);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.date_range_outlined,
                                            color: AppColors.greenColor,
                                          )),
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return "Birth Date Required";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.none,
                                      controller: dobController),
                                  MethodHelper.heightBox(height: 1.h),
                                  CustomDropDownWidget(
                                    hintText: "Select Branch",
                                    prefixIcon: Icons.storefront_outlined,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "data",
                                        child: Text("data"),
                                      ),
                                      DropdownMenuItem(
                                        value: "data2",
                                        child: Text("data2"),
                                      ),
                                      DropdownMenuItem(
                                        value: "data3",
                                        child: Text("data3"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        branchSelection = value as String;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Branch Required";
                                      }
                                      return null;
                                    },
                                  ),
                                  MethodHelper.heightBox(height: 1.h),
                                  CustomTextFieldWidget(
                                    hintText: "Address",
                                    controller: addressController,
                                    minLines: 2,
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icons.location_on_outlined,
                                    validator: (value) {
                                      if (value?.isEmpty == true) {
                                        return "Address required";
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
            child: PrimaryBtn(
                btnText: widget.UserStatus == "STAFF" ? "Login" : "Submit",
                onTap: () {
                  if (widget.UserStatus == "STAFF") {
                    if (staffForm.currentState!.validate()) {
                      pushRemoveUntil(context, HomeScreen(isDoctor: true));
                      print("staff validated");
                      return;
                    }
                  } else if (widget.UserStatus == "PATIENT") {
                    if (patientForm.currentState!.validate()) {
                      pushRemoveUntil(context, HomeScreen(isDoctor: false));
                      print("patient validated");
                      return;
                    }
                  } else {
                    if (newForm.currentState!.validate()) {
                      pushRemoveUntil(context, HomeScreen(isDoctor: false));
                      print("new user validated");
                    }
                  }
                })),
      ),
    );
  }
}
