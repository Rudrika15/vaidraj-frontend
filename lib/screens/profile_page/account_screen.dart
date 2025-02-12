import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/update_user_profile_model.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/mobile_verification/mobile_verification.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_exit_dialog_widget.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import '../../services/update_user_profile/update_user_profile.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../utils/widget_helper/widget_helper.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/loader.dart';
import '../home/home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<ProfilePage> with NavigateHelper {
  TextEditingController nameController = TextEditingController();
  String? role;
  bool isLoading = true;
  TextEditingController emailController = TextEditingController();

  TextEditingController numberController = TextEditingController();

  int? branchSelection;
  String? dob;
  TextEditingController dobController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  bool isEditing = false;
  DateTime? dateTime;
  GlobalKey<FormState> newForm = GlobalKey<FormState>();
  UpdateUserProfileService service = UpdateUserProfileService();

  ////
  Future<void> getUserInfo() async {
    role = await SharedPrefs.getRole();
    nameController.text = await SharedPrefs.getName();
    emailController.text = await SharedPrefs.getEmail();
    numberController.text = await SharedPrefs.getMobileNumber();
    branchSelection = int.parse(await SharedPrefs.getBranchId());
    dobController.text = await SharedPrefs.getDOB();
    addressController.text = await SharedPrefs.getAddress();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    var branchProvider = Provider.of<GetBrachProvider>(context, listen: false);
    if (branchProvider.getBranchModel == null) {
      branchProvider.getBranch(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: role == "admin" || role == "doctor" ? false : true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        String role = await SharedPrefs.getRole();
        if (role == "admin" || role == "doctor") {
          pushRemoveUntil(
            context,
            HomeScreen(
              isAdmin: role == "admin",
              isDoctor: role == "doctor",
              screenIndex: 2,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Consumer2<LocalizationProvider, GetBrachProvider>(
            builder: (profileContext, langProvider, branchProvider, child) =>
                isLoading
                    ? const Center(
                        child: Loader(),
                      )
                    : CustomContainer(
                        width: 100.w,
                        backGroundColor: AppColors
                            .whiteColor, // A white background to separate content
                        padding: EdgeInsets.only(top: 5.h),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomContainer(
                                child: Column(
                                  children: [
                                    // Avatar with border and gradient
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColors.greenColor,
                                              AppColors.backgroundColor
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 8.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            MethodHelper.getInitials(
                                                name: nameController.text),
                                            style: TextSizeHelper
                                                .mediumHeaderStyle
                                                .copyWith(
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    MethodHelper.heightBox(height: 4.h),

                                    Form(
                                        key: newForm,
                                        child: CustomContainer(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Column(
                                              children: [
                                                CustomTextFieldWidget(
                                                  enabled: isEditing,
                                                  decoration: MethodHelper
                                                      .brownUnderLineBorder(
                                                          hintText: langProvider
                                                              .translate(
                                                                  "name"),
                                                          prefixIcon: Icons
                                                              .person_outline_sharp),
                                                  controller: nameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLength: 30,
                                                  validator: (value) {
                                                    if (value?.isEmpty ==
                                                        true) {
                                                      return langProvider
                                                          .translate("nameReq");
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                MethodHelper.heightBox(
                                                    height: 1.h),
                                                CustomTextFieldWidget(
                                                  enabled: isEditing,
                                                  decoration: MethodHelper
                                                      .brownUnderLineBorder(
                                                          hintText: langProvider
                                                              .translate(
                                                                  "contactNumber"),
                                                          prefixIcon:
                                                              Icons.phone),
                                                  controller: numberController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 10,
                                                  validator: (value) {
                                                    if (value?.isEmpty ==
                                                        true) {
                                                      return langProvider
                                                          .translate(
                                                              "numberReq");
                                                    }
                                                    if (value?.contains(RegExp(
                                                            r"[ ,-.]")) ??
                                                        true) {
                                                      return langProvider
                                                          .translate(
                                                              "mobileNotValid");
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                MethodHelper.heightBox(
                                                    height: 1.h),
                                                CustomTextFieldWidget(
                                                  enabled: isEditing,
                                                  decoration: MethodHelper
                                                      .brownUnderLineBorder(
                                                          hintText: langProvider
                                                              .translate(
                                                                  "email"),
                                                          prefixIcon: Icons
                                                              .email_outlined),
                                                  controller: emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  maxLength: 40,
                                                  validator: (value) {
                                                    if (value?.isEmpty ==
                                                        true) {
                                                      return langProvider
                                                          .translate("email");
                                                    } else {
                                                      if (!RegExp(
                                                              r'^(?!.*[<>\";])([a-zA-Z0-9._%+-]+)@[a-zA-Z.-]+\.[a-zA-Z]{2,}$')
                                                          .hasMatch(
                                                              value ?? "")) {
                                                        return langProvider
                                                            .translate(
                                                                "emailNotValid");
                                                      }
                                                      ;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (isEditing) {
                                                      dateTime =
                                                          await showDatePicker(
                                                              context:
                                                                  profileContext,
                                                              firstDate:
                                                                  DateTime(
                                                                      1950),
                                                              lastDate: DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day));
                                                      if (dob != null) {
                                                        dobController
                                                            .text = DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(dateTime!);
                                                      }
                                                    }
                                                  },
                                                  child: CustomTextFieldWidget(
                                                      enabled: false,
                                                      decoration: MethodHelper
                                                          .brownUnderLineBorder(
                                                              hintText: langProvider
                                                                  .translate(
                                                                      "dateOfBirth"),
                                                              prefixIcon: Icons
                                                                  .cake_outlined),
                                                      suffix: const Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color: AppColors
                                                            .greenColor,
                                                      ),
                                                      validator: (value) {
                                                        if (value?.isEmpty ==
                                                            true) {
                                                          return langProvider
                                                              .translate(
                                                                  "dateOfBirthReq");
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.none,
                                                      controller:
                                                          dobController),
                                                ),
                                                MethodHelper.heightBox(
                                                    height: 1.h),
                                                if (role != 'admin') ...[
                                                  branchProvider.isLoading
                                                      ? const Center(
                                                          child: Loader())
                                                      : CustomDropDownWidget(
                                                          decoration: MethodHelper
                                                              .brownUnderLineBorder(
                                                            prefixIcon: Icons
                                                                .storefront_outlined,
                                                            prefixColor:
                                                                AppColors
                                                                    .greenColor,
                                                            hintText: langProvider
                                                                .translate(
                                                                    "selectBranch"),
                                                          ),
                                                          value: branchSelection
                                                              as int,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          items: branchProvider
                                                                      .getBranchModel
                                                                      ?.data
                                                                      ?.isNotEmpty ==
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
                                                                          ?.data?[
                                                                              index]
                                                                          .id,
                                                                      child:
                                                                          Text(
                                                                        branchProvider.getBranchModel?.data?[index].branchName ??
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
                                                          onChanged: !isEditing
                                                              ? null
                                                              : (value) {
                                                                  setState(() {
                                                                    branchSelection =
                                                                        value
                                                                            as int;
                                                                  });
                                                                },
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return langProvider
                                                                  .translate(
                                                                      "branchReq");
                                                            }
                                                            return null;
                                                          },
                                                        )
                                                ],
                                                MethodHelper.heightBox(
                                                    height: 1.h),
                                                CustomTextFieldWidget(
                                                  enabled: isEditing,
                                                  decoration: MethodHelper
                                                      .brownUnderLineBorder(
                                                          hintText: langProvider
                                                              .translate(
                                                                  "address"),
                                                          prefixIcon: Icons
                                                              .location_on_outlined),
                                                  controller: addressController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    if (value?.isEmpty ==
                                                        true) {
                                                      return langProvider
                                                          .translate(
                                                              "addressReq");
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            )))
                                  ],
                                ),
                              ),

                              MethodHelper.heightBox(height: 2.h),

                              // Submit Button
                              SizedBox(
                                height: 5.h,
                                child: PrimaryBtn(
                                    btnText: isEditing ? "Submit" : "Edit",
                                    backGroundColor: AppColors.brownColor,
                                    onTap: () async {
                                      if (isEditing) {
                                        // if new user than do this
                                        if (newForm.currentState!.validate()) {
                                          await service
                                              .updateUserProfile(
                                                  context: profileContext,
                                                  branchId: branchSelection
                                                      .toString(),
                                                  name: nameController.text,
                                                  email: emailController.text,
                                                  address:
                                                      addressController.text,
                                                  dob: dobController.text)
                                              .then((value) {
                                            if (value?.success == true) {
                                              WidgetHelper.customSnackBar(
                                                  context: profileContext,
                                                  title:
                                                      "User Account Created");
                                              setState(() {
                                                isEditing = false;
                                              });
                                            }
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          isEditing = true;
                                        });
                                      }
                                    }),
                              ),
                              MethodHelper.heightBox(height: 1.h),
                              // Logout Button
                              SizedBox(
                                height: 5.h,
                                // width: 25.w,
                                child: PrimaryBtn(
                                  btnText: "Logout",
                                  textStyle: TextSizeHelper.smallHeaderStyle
                                      .copyWith(color: AppColors.errorColor),
                                  backGroundColor: AppColors.whiteColor,
                                  onTap: () => showDialog(
                                    context: profileContext,
                                    builder: (profileContext) => CustomAlertBox(
                                      content: "Do You Really Want To Logout?",
                                      heading: "Are You Sure?",
                                      secondBtnText: "LogOut",
                                      color: AppColors.errorColor,
                                      onPressedSecondBtn: () async {
                                        await SharedPrefs.clearShared();
                                        pushRemoveUntil(
                                            context, MobileVerification());
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
      ),
    );
  }
}
