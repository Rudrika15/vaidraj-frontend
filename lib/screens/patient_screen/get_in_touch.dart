import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/home/home_screen.dart';
import 'package:vaidraj/services/contact_service/contact_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/in_app_heading.dart';
import 'package:vaidraj/widgets/primary_btn.dart';
import "dart:math" as math;
import '../../constants/strings.dart';
import '../../widgets/custom_text_field_widget.dart';

class GetInTouchScreen extends StatelessWidget {
  GetInTouchScreen({super.key});
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
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, langProvider, child) => SafeArea(
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
            padding: EdgeInsets.only(bottom: AppSizes.size30),
            child: Column(
              children: [
                LogoWithInfoContainer(
                  children: [
                    ContatInfoRender(
                      icon: Icons.email,
                      info: "drkrishnaravalmcdcr@gmail.com",
                    ),
                    ContatInfoRender(
                      icon: Icons.email,
                      info: "scientistdrhraval@gmail.com",
                    ),
                    MethodHelper.heightBox(height: 2.h),
                    ContatInfoRender(
                      icon: Icons.phone,
                      info: "+91 98247 49263",
                    ),
                    ContatInfoRender(
                      icon: Icons.phone,
                      info: "+91 88288 88202",
                    ),
                    ContatInfoRender(
                      icon: Icons.phone,
                      info: "+91 88980 88980 ,",
                    ),
                    ContatInfoRender(
                      icon: Icons.phone,
                      info: "+91 98259 42366",
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
                AddressRender(
                    text:
                        "Ahmedabad - MCDCR Ayurveda,A- 501 , 5th floor , Fairdale House ,opp Xavier’s girls House, CG Road, Swastik Char Rasta , Navarangpura Ahmedabad"),
                AddressRender(
                    text:
                        "Surendranagar - MCDCR Ayurveda,2nd  floor , Kailash Chembur , Vadilal Chowk ,  CJ Hospital  Road   , Surendranagar."),
                InScreenHeading(
                  heading: langProvider.translate('contact'),
                  endIndent: 70.w,
                ),
                CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Form(
                      key: contactFormKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFieldWidget(
                                  decoration: MethodHelper.greenUnderLineBorder(
                                      hintText:
                                          langProvider.translate('firstName')),
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
                                  decoration: MethodHelper.greenUnderLineBorder(
                                      hintText:
                                          langProvider.translate('lastName')),
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
                                ;
                              }
                              return null;
                            },
                          ),
                          MethodHelper.heightBox(height: 1.h),
                          CustomTextFieldWidget(
                            decoration: MethodHelper.greenUnderLineBorder(
                                hintText:
                                    langProvider.translate("contactNumber")),
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
                                  hintText: langProvider.translate('subject')),
                              maxLines: 2,
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return langProvider.translate('subjectReq');
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: subjectController),
                          MethodHelper.heightBox(height: 1.h),
                          CustomTextFieldWidget(
                            decoration: MethodHelper.greenUnderLineBorder(
                                hintText: langProvider.translate("message")),
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
                                  if (contactFormKey.currentState!.validate()) {
                                    bool success = await service.ContactVaidraj(
                                        context: context,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        mobile: contactNumberController.text,
                                        subject: subjectController.text,
                                        message: messageController.text);
                                    if (success) {
                                      WidgetHelper.customSnackBar(
                                          context: context,
                                          title: "Sent Successfully");
                                    }
                                  }
                                  ;
                                }),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ))
        ],
      )),
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

class ContatInfoRender extends StatelessWidget {
  const ContatInfoRender({super.key, required this.icon, required this.info});
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
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.size10, vertical: AppSizes.size10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MethodHelper.widthBox(width: 5.w),
          const Padding(
            padding: EdgeInsets.only(top: AppSizes.size10),
            child: const Icon(Icons.location_on, color: AppColors.greenColor),
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
