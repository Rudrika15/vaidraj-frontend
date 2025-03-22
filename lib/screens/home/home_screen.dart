import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/provider/profile_provider.dart';
import 'package:vaidraj/screens/feedback/feedback.dart';
import 'package:vaidraj/screens/profile_page/account_screen.dart';
import 'package:vaidraj/screens/admin_screens/home_screen.dart';
import 'package:vaidraj/screens/admin_screens/patients_screen.dart';
import 'package:vaidraj/screens/notification/notifications_screen.dart';
import 'package:vaidraj/screens/patient_screen/about_us.dart';
import 'package:vaidraj/screens/patient_screen/all_article.dart';
import 'package:vaidraj/screens/patient_screen/all_youtube.dart';
import 'package:vaidraj/screens/patient_screen/appointment.dart';
import 'package:vaidraj/screens/patient_screen/get_in_touch.dart';
import 'package:vaidraj/screens/patient_screen/medical_history.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/screens/patient_screen/specialities.dart';
import 'package:vaidraj/services/updateFCMToken/update_fcm_token.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:vaidraj/utils/widget_helper/widget_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../constants/color.dart';
import '../../widgets/custom_exit_dialog_widget.dart';
import '../admin_screens/appointment_screen.dart';
import '../delete_account_screen/delete_acc_screen.dart';
import '../mobile_verification/mobile_verification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isDoctor,
    required this.isAdmin,
    this.screenIndex,
  });
  final bool isDoctor;
  final bool isAdmin;
  final int? screenIndex;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with NavigateHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  int _selectedNavTabIndex = 0;
  // String userName = "";
  final List<Widget> screensNav = const [
    AdminHomeScreen(),
    AdminAppointmentScreen(),
    AdminPatientsScreen(),
    ProfilePage()
  ];
  final List<String> navTabNames = const ["Appointment", "Patients", "Account"];

  final List<Widget> screensTab = [
    PatientHomeScreen(),
    SpecialitiesScreen(),
    Appointment(),
    MedicalHistoryScreen(),
    AllArticlePage(),
    AllYouTubeVideos(),
    AboutUsScreen(),
    GetInTouchScreen(),
    DeleteAccountScreen()
  ];

  final List<Map<String, dynamic>> drawerOptions = [
    {'icon': Icons.home_rounded, 'text': "home"},
    {'icon': Icons.stars_rounded, 'text': "specialities"},
    {'icon': Icons.auto_stories_rounded, 'text': "appointment"},
    {'icon': Icons.medical_information_rounded, 'text': "medicalHistory"},
    {'icon': Icons.article_sharp, 'text': "article"},
    {'icon': Icons.video_collection, 'text': "videos"},
    {'icon': Icons.verified_rounded, 'text': "aboutUs"},
    {'icon': Icons.contact_phone, 'text': "getInTouch"},
    {'icon': Icons.delete_forever, 'text': "deleteAcc"},
  ];
  final UpdateFcmTokenService fcmTokenService = UpdateFcmTokenService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserName();
    getAndStoreFCMToken();
    setupInteractedMessage();
    if (widget.isAdmin || widget.isDoctor) {
      _selectedNavTabIndex = widget.screenIndex ?? 0;
    } else {
      _selectedTabIndex = widget.screenIndex ?? 0;
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification?.body ==
        "How Are You feeling Now Please add feedback") {
      push(context, const FeedbackScreen());
    }
    if (message.notification?.body == "Please Take New Appointment") {
      push(
          context,
          const HomeScreen(
            isAdmin: false,
            isDoctor: false,
            screenIndex: 2,
          ));
    }
  }

  Future<void> getAndStoreFCMToken() async {
    try {
      // Retrieve the FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      // print('getting => $fcmToken');
      if (fcmToken != null) {
        await SharedPrefs.saveFCMToken(fcmToken);
        await fcmTokenService.updateFCMToken(context: context);
      } else {
        // print("FCM Token is null");
      }
    } catch (e) {
      // print("Error retrieving FCM token: $e");
      WidgetHelper.customSnackBar(
          context: context, title: "Failed to Load FCMToken", isError: true);
    }
  }

  // Future<String> getUserName() async {
  //   String u = await SharedPrefs.getName();
  //   setState(() {
  //     userName = u;
  //   });
  //   print(u);
  //   return u;
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer2<LocalizationProvider, AllDiseaseProvider>(
        builder: (context, langProvider, diseaseProvider, child) => Scaffold(
          endDrawerEnableOpenDragGesture: false,
          // Disable drawer swipe gesture here
          drawerEnableOpenDragGesture: false,
          key: _scaffoldKey,
          backgroundColor: AppColors.whiteColor,
          endDrawer: _buildDrawer(
              langProvider: langProvider,
              diseaseProvider: diseaseProvider,
              context: context),
          appBar: _buildAppBar(
            isDoctor: widget.isDoctor,
            isAdmin: widget.isAdmin,
            langProvider: langProvider,
          ),
          body: widget.isDoctor || widget.isAdmin
              ? screensNav[_selectedNavTabIndex]
              : screensTab[_selectedTabIndex],
          bottomNavigationBar: widget.isDoctor || widget.isAdmin
              ? _buildBottomNavigationBar(langProvider: langProvider)
              : null,
        ),
      ),
    );
  }

  Drawer _buildDrawer(
      {required LocalizationProvider langProvider,
      required AllDiseaseProvider diseaseProvider,
      required BuildContext context}) {
    return Drawer(
      backgroundColor: AppColors.lightBackGroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DrawerHeaderWidget(),
            const Divider(),
            ...List.generate(drawerOptions.length, (index) {
              return DrawerOptionWidget(
                iconColor: index == 8 ? AppColors.errorColor : null,
                icon: drawerOptions[index]['icon'],
                text: langProvider.translate(drawerOptions[index]['text']),
                isSelected: _selectedTabIndex == index,
                onTap: () {
                  setTabIndexAndCloseDrawer(index);
                },
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<GetBrachProvider>(
                  builder: (context, branchProvider, child) => GestureDetector(
                    onTap: () async {
                      await langProvider
                          .changeLanguage(
                              context: context,
                              locale: langProvider.currentLocale == "en"
                                  ? "hi"
                                  : "en")
                          .then((isSuccess) {
                        if (isSuccess) {
                          /// this is useing for update data in appointment page to update disease id
                          diseaseProvider.resetState(context: context);
                          branchProvider.resetBranchAddressModel(
                              context: context);
                        } else {
                          // print("pagination not refreshed");
                        }
                      });
                    },
                    child: langProvider.isLoading
                        ? const Center(
                            child: Loader(),
                          )
                        : CustomContainer(
                            borderColor: AppColors.brownColor,
                            borderWidth: 0.3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.h),
                            backGroundColor: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(5.w),
                            child: Text(
                              "${langProvider.currentLocale != "en" ? "English" : "हिन्दी"}",
                              style: TextSizeHelper.smallHeaderStyle,
                            ),
                          ),
                  ),
                ),
                MethodHelper.widthBox(width: 1.h),
                GestureDetector(
                  onTap: () async => showDialog(
                    context: context,
                    builder: (context) => CustomAlertBox(
                      content:
                          langProvider.translate("doYouReallyWantToLogout"),
                      heading: langProvider.translate('areYouSure'),
                      firstBtnText: langProvider.translate('cancel'),
                      secondBtnText: langProvider.translate('logout'),
                      color: AppColors.errorColor,
                      onPressedSecondBtn: () async {
                        await SharedPrefs.clearShared();
                        pushRemoveUntil(context, MobileVerification());
                      },
                    ),
                  ),
                  child: langProvider.isLoading
                      ? const Center(
                          child: Loader(),
                        )
                      : CustomContainer(
                          borderColor: Colors.black,
                          borderWidth: 0.3,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          backGroundColor: AppColors.errorColor,
                          borderRadius: BorderRadius.circular(5.w),
                          child: Text(
                            langProvider.translate('logout'),
                            style: TextSizeHelper.smallHeaderStyle
                                .copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      {required bool isDoctor,
      required bool isAdmin,
      required LocalizationProvider langProvider}) {
    ProfileProvider profileProvider = context.watch<ProfileProvider>();
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      title: Text(
        isDoctor || isAdmin
            ? _selectedNavTabIndex == 0
                ? "Hello, ${profileProvider.userModel.data?.name}"
                : _selectedNavTabIndex == 1
                    ? navTabNames[0]
                    : _selectedNavTabIndex == 2
                        ? navTabNames[1]
                        : navTabNames[2]
            : _selectedTabIndex == 0
                ? "Hello, ${profileProvider.userModel.data?.name}"
                : langProvider
                    .translate(drawerOptions[_selectedTabIndex]['text']),
        style: TextSizeHelper.mediumTextStyle
            .copyWith(color: AppColors.brownColor),
      ),
      leading: isDoctor || isAdmin
          ? _selectedNavTabIndex != 0
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: const VaidrajLogo(),
                )
          : _selectedTabIndex != 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.brownColor,
                  ))
              : Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: const VaidrajLogo(),
                ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget>? _buildAppBarActions() {
    List<Widget> actions = [];
    widget.isDoctor || widget.isAdmin
        ? _selectedNavTabIndex != 0
            ? null
            : actions.add(IconButton.filledTonal(
                onPressed: () {
                  push(
                      context,
                      NotificationsScreen(
                        isPatient: !widget.isAdmin && !widget.isDoctor,
                      ));
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.backgroundColor)),
                icon: const Icon(Icons.notifications,
                    color: AppColors.brownColor),
              ))
        : _selectedTabIndex != 0
            ? null
            : actions.add(IconButton.filledTonal(
                onPressed: () {
                  push(
                      context,
                      NotificationsScreen(
                        isPatient: !widget.isAdmin && !widget.isDoctor,
                      ));
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.backgroundColor)),
                icon: const Icon(Icons.notifications,
                    color: AppColors.brownColor),
              ));

    if (widget.isDoctor || widget.isAdmin) {
      actions.add(SizedBox(width: 5.w));
    } else {
      actions.add(
          EndDrawerButton(onPressed: _scaffoldKey.currentState?.openEndDrawer));
    }

    return actions;
  }

  /// will build navbar if logged in user is staff member
  ClipRRect _buildBottomNavigationBar(
      {required LocalizationProvider langProvider}) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: NavigationBar(
        selectedIndex: _selectedNavTabIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedNavTabIndex = value;
          });
        },
        indicatorColor: AppColors.lightBackGroundColor,
        backgroundColor: AppColors.backgroundColor,
        destinations: [
          NavigationDestination(
              selectedIcon:
                  const Icon(Icons.home_rounded, color: AppColors.greenColor),
              icon: const Icon(Icons.home_rounded, color: AppColors.brownColor),
              label: langProvider.translate("home")),
          NavigationDestination(
              selectedIcon: const Icon(Icons.auto_stories_rounded,
                  color: AppColors.greenColor),
              icon: const Icon(Icons.auto_stories_rounded,
                  color: AppColors.brownColor),
              label: langProvider.translate("appointment")),
          NavigationDestination(
              selectedIcon: const Icon(Icons.personal_injury_rounded,
                  color: AppColors.greenColor),
              icon: const Icon(Icons.personal_injury_rounded,
                  color: AppColors.brownColor),
              label: langProvider.translate("patients")),
          NavigationDestination(
              selectedIcon:
                  const Icon(Icons.person, color: AppColors.greenColor),
              icon: const Icon(Icons.person, color: AppColors.brownColor),
              label: langProvider.translate("account")),
        ],
      ),
    );
  }

  /// set tab index and and close the drawer
  void setTabIndexAndCloseDrawer(int index) {
    setState(() {
      _selectedTabIndex = index;
      _scaffoldKey.currentState?.closeEndDrawer();
    });
  }
}

class VaidrajLogo extends StatelessWidget {
  const VaidrajLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppStrings.logo);
  }
}

/// this is used to rander tab in drawer
class DrawerOptionWidget extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;
  const DrawerOptionWidget(
      {super.key,
      required this.isSelected,
      required this.icon,
      required this.text,
      required this.onTap,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        margin: EdgeInsets.only(left: 10.w),
        child: ListTile(
          tileColor: isSelected ? AppColors.backgroundColor : null,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.w),
              topLeft: Radius.circular(10.w),
            ),
            side: BorderSide(color: AppColors.lightBackGroundColor, width: 0.1),
          ),
          leading: Icon(
            icon,
            color: isSelected
                ? iconColor ?? AppColors.greenColor
                : iconColor ?? AppColors.brownColor,
            size: 7.w,
          ),
          title: Text(
            text,
            style: TextSizeHelper.smallHeaderStyle.copyWith(
              color: isSelected
                  ? iconColor ?? AppColors.greenColor
                  : iconColor ?? AppColors.brownColor,
            ),
          ),
          contentPadding: EdgeInsets.only(right: 0, left: 10.w),
          trailing: isSelected
              ? VerticalDivider(
                  color: iconColor ?? AppColors.greenColor, thickness: 10)
              : null,
        ),
      ),
    );
  }
}

/// have used this to render header in drawer
class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({
    super.key,
  });
  @override
  State<DrawerHeaderWidget> createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget>
    with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = context.watch<ProfileProvider>();
    return CustomContainer(
      width: 80.w,
      height: 20.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomContainer(
              borderColor: AppColors.brownColor,
              backGroundColor: AppColors.greenColor,
              shape: BoxShape.circle,
              borderWidth: 2,
              child: Stack(children: [
                CircleAvatar(
                  backgroundColor: AppColors.backgroundColor,
                  radius: 10.w,
                  child: Text(
                      profileProvider.userModel.data?.name?.isNotEmpty == true
                          ? profileProvider.userModel.data?.name
                                  ?.substring(0, 1) ??
                              ""
                          : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextSizeHelper.mediumHeaderStyle),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => push(context, ProfilePage()),
                    child: const CustomContainer(
                      shape: BoxShape.circle,
                      borderColor: AppColors.brownColor,
                      backGroundColor: AppColors.brownColor,
                      child: Icon(
                        Icons.edit,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            MethodHelper.heightBox(height: 2.h),
            Text(
              profileProvider.userModel.data?.name ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextSizeHelper.mediumHeaderStyle
                  .copyWith(color: AppColors.brownColor),
            ),
          ],
        ),
      ),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({super.key, required this.number});
  final String number;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Text(number)),
    );
  }
}
