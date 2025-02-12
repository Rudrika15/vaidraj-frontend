import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/services/contact_service/contact_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/in_app_heading.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import "dart:math" as math;
import '../../constants/strings.dart';
import '../../models/branch_address_model.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../widgets/custom_text_field_widget.dart';

class GetInTouchScreen extends StatefulWidget {
  const GetInTouchScreen({super.key});

  @override
  State<GetInTouchScreen> createState() => _GetInTouchScreenState();
}

class _GetInTouchScreenState extends State<GetInTouchScreen>
    with NavigateHelper {
  GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController contactNumberController = TextEditingController();

  TextEditingController subjectController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  // service
  ContactService service = ContactService();
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<GetBrachProvider>(context, listen: false);
    if (mounted) {
      if (provider.addressModel == null) {
        provider.getBrachAddress(context: context);
      } else {
        print("Branch address is here already");
      }
    }
  }

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
      child: Consumer2<LocalizationProvider, GetBrachProvider>(
        builder: (context, langProvider, branchProvider, child) => SafeArea(
            child: RefreshIndicator(
          color: AppColors.brownColor,
          backgroundColor: AppColors.lightBackGroundColor,
          onRefresh: () async {
            branchProvider.resetBranchAddressModel(context: context);
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
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
              SafeArea(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSizes.size30),
                child: Column(
                  children: [
                    LogoWithInfoContainer(
                      children: [
                        const ContactInfoRender(
                            icon: Icons.email, info: AppStrings.email),
                        const ContactInfoRender(
                          icon: Icons.email,
                          info: AppStrings.email2,
                        ),
                        MethodHelper.heightBox(height: 2.h),
                        const ContactInfoRender(
                          icon: Icons.phone,
                          info: AppStrings.mobile,
                        ),
                        const ContactInfoRender(
                          icon: Icons.phone,
                          info: AppStrings.mobile2,
                        ),
                        const ContactInfoRender(
                          icon: Icons.phone,
                          info: AppStrings.mobile3,
                        ),
                        const ContactInfoRender(
                          icon: Icons.phone,
                          info: AppStrings.mobile4,
                        ),
                      ],
                    ),
                    MethodHelper.heightBox(height: 5.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size20,
                      ),
                      child: Text(
                        langProvider.translate("getInTouchPara"),
                        style: TextSizeHelper.smallTextStyle,
                      ),
                    ),
                    MethodHelper.heightBox(height: 2.h),
                    ///// render branch address fetching from server
                    branchProvider.isLoading
                        ? const Center(
                            child: Loader(),
                          )
                        : branchProvider.addressModel?.data?.isEmpty == true
                            ? Text(langProvider.translate('noDataFound'))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (BranchAddress address
                                      in branchProvider.addressModel?.data ??
                                          []) ...[
                                    AddressRender(
                                        text: address.displayAddress ??
                                            "Coming Soon")
                                  ]
                                ],
                              ),
                    InScreenHeading(
                      heading: langProvider.translate('contact'),
                      endIndent: 70.w,
                    ),
                    CustomContainer(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSizes.size20),
                        child: Form(
                          key: contactFormKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.greenUnderLineBorder(
                                              hintText: langProvider
                                                  .translate('firstName')),
                                      controller: firstNameController,
                                      keyboardType: TextInputType.text,
                                      maxLength: 30,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate('firstNameReq');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  MethodHelper.widthBox(width: AppSizes.size10),
                                  Expanded(
                                    child: CustomTextFieldWidget(
                                      decoration:
                                          MethodHelper.greenUnderLineBorder(
                                              hintText: langProvider
                                                  .translate('lastName')),
                                      controller: lastNameController,
                                      keyboardType: TextInputType.text,
                                      maxLength: 30,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return langProvider
                                              .translate('lastNameReq');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              MethodHelper.heightBox(height: 1.h),
                              CustomTextFieldWidget(
                                decoration: MethodHelper.greenUnderLineBorder(
                                    hintText: langProvider.translate('email')),
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 40,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return langProvider.translate("emailReq");
                                  } else {
                                    if (!RegExp(
                                            r'^(?!.*[<>\";])([a-zA-Z0-9._%+-]+)@[a-zA-Z.-]+\.[a-zA-Z]{2,}$')
                                        .hasMatch(value ?? "")) {
                                      return langProvider
                                          .translate('emailNotValid');
                                    }
                                  }
                                  return null;
                                },
                              ),
                              MethodHelper.heightBox(height: 1.h),
                              CustomTextFieldWidget(
                                decoration: MethodHelper.greenUnderLineBorder(
                                    hintText: langProvider
                                        .translate("contactNumber")),
                                controller: contactNumberController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return langProvider.translate("numberReq");
                                  }
                                  return null;
                                },
                              ),
                              MethodHelper.heightBox(height: 1.h),
                              CustomTextFieldWidget(
                                  decoration: MethodHelper.greenUnderLineBorder(
                                      hintText:
                                          langProvider.translate('subject')),
                                  maxLines: 2,
                                  validator: (value) {
                                    if (value?.isEmpty == true) {
                                      return langProvider
                                          .translate('subjectReq');
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: subjectController),
                              MethodHelper.heightBox(height: 1.h),
                              CustomTextFieldWidget(
                                decoration: MethodHelper.greenUnderLineBorder(
                                    hintText:
                                        langProvider.translate("message")),
                                controller: messageController,
                                minLines: 2,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return langProvider.translate("messageReq");
                                  }
                                  return null;
                                },
                              ),
                              MethodHelper.heightBox(height: 3.h),
                              SizedBox(
                                width: 50.w,
                                child: PrimaryBtn(
                                    btnText: langProvider.translate("submit"),
                                    onTap: () async {
                                      if (contactFormKey.currentState!
                                          .validate()) {
                                        bool success =
                                            await service.ContactVaidraj(
                                                context: context,
                                                firstName:
                                                    firstNameController.text,
                                                lastName:
                                                    lastNameController.text,
                                                email: emailController.text,
                                                mobile: contactNumberController
                                                    .text,
                                                subject: subjectController.text,
                                                message:
                                                    messageController.text);
                                        if (success) {
                                          WidgetHelper.customSnackBar(
                                              context: context,
                                              title: langProvider
                                                  .translate('messageSent'));

                                          /// clean controllers after success
                                          firstNameController.clear();
                                          lastNameController.clear();
                                          emailController.clear();
                                          contactNumberController.clear();
                                          subjectController.clear();
                                          messageController.clear();
                                        }
                                      }
                                    }),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ))
            ],
          ),
        )),
      ),
    );
  }
}

class LogoWithInfoContainer extends StatelessWidget {
  const LogoWithInfoContainer({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size10, vertical: AppSizes.size20),
      backGroundColor: AppColors.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
              flex: 2,
              child: CustomContainer(
                  margin: EdgeInsets.symmetric(horizontal: AppSizes.size20),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.24),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 0)),
                  ],
                  child: VaidrajLogo())),
          Expanded(
              flex: 3,
              child: CustomContainer(
                child: Column(children: children),
              ))
        ],
      ),
    );
  }
}

class ContactInfoRender extends StatelessWidget {
  const ContactInfoRender({super.key, required this.icon, required this.info});
  final IconData icon;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.greenColor,
        ),
        MethodHelper.widthBox(width: AppSizes.size10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info),
            ],
          ),
        )
      ],
    );
  }
}

class AddressRender extends StatelessWidget {
  const AddressRender({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size10, vertical: AppSizes.size10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MethodHelper.widthBox(width: 5.w),
          const Padding(
            padding: EdgeInsets.only(top: AppSizes.size10),
            child: Icon(Icons.location_on, color: AppColors.greenColor),
          ),
          MethodHelper.widthBox(width: 2.w), // Bullet point icon
          const SizedBox(width: 8), // Space between the bullet and the text
          Expanded(
            child: Text(text, style: TextSizeHelper.xSmallTextStyle),
          ),
        ],
      ),
    );
  }
}
