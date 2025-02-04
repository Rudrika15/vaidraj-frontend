import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/provider/all_disease_provider.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/screens/admin_screens/account_screen.dart';
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
import 'package:vaidraj/screens/patient_screen/products.dart';
import 'package:vaidraj/screens/patient_screen/specialities.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import '../../constants/color.dart';
import '../admin_screens/appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isDoctor,
    required this.isAdmin,
  });
  final bool isDoctor;
  final bool isAdmin;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with NavigateHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  int _selectedNavTabIndex = 0;
  String userName = "";
  final List<Widget> screensNav = const [
    AdminHomeScreen(),
    PrescriptionPage(),
    AdminPatientsScreen(),
    AdminProfilePage()
  ];
  final List<String> navTabNames = const ["Appointment", "Patients", "Account"];

  final List<Widget> screensTab = [
    PatientHomeScreen(),
    SpecialitiesScreen(),
    ProductsScreen(),
    Appointment(),
    MedicalHistoryScreen(),
    AllArticlePage(),
    AllYouTubeVideos(),
    AboutUsScreen(),
    GetInTouchScreen(),
  ];

  final List<Map<String, dynamic>> drawerOptions = [
    {'icon': Icons.home_rounded, 'text': "home"},
    {'icon': Icons.stars_rounded, 'text': "specialities"},
    {'icon': Icons.inventory_2_rounded, 'text': "products"},
    {'icon': Icons.auto_stories_rounded, 'text': "appointment"},
    {'icon': Icons.medical_information_rounded, 'text': "medicalHistory"},
    {'icon': Icons.article_sharp, 'text': "article"},
    {'icon': Icons.video_collection, 'text': "videos"},
    {'icon': Icons.verified_rounded, 'text': "aboutUs"},
    {'icon': Icons.contact_phone, 'text': "getInTouch"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  Future<String> getUserName() async {
    String u = await SharedPrefs.getName();
    setState(() {
      userName = u;
    });
    print(u);
    return u;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocalizationProvider, AllDiseaseProvider>(
      builder: (context, langProvider, diseaseProvider, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.whiteColor,
        endDrawer: _buildDrawer(
            langProvider: langProvider,
            diseaseProvider: diseaseProvider,
            userName: userName,
            context: context),
        appBar: _buildAppBar(
            isDoctor: widget.isDoctor,
            isAdmin: widget.isAdmin,
            langProvider: langProvider,
            userName: userName),
        body: widget.isDoctor || widget.isAdmin
            ? screensNav[_selectedNavTabIndex]
            : screensTab[_selectedTabIndex],
        bottomNavigationBar: widget.isDoctor || widget.isAdmin
            ? _buildBottomNavigationBar(langProvider: langProvider)
            : null,
      ),
    );
  }

  Drawer _buildDrawer(
      {required LocalizationProvider langProvider,
      required AllDiseaseProvider diseaseProvider,
      required String userName,
      required BuildContext context}) {
    return Drawer(
      backgroundColor: AppColors.lightBackGroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DrawerHeaderWidget(
              userName: userName,
            ),
            const Divider(),
            ...List.generate(drawerOptions.length, (index) {
              return DrawerOptionWidget(
                icon: drawerOptions[index]['icon'],
                text: langProvider.translate(drawerOptions[index]['text']),
                isSelected: _selectedTabIndex == index,
                onTap: () {
                  setTabIndexAndCloseDrawer(index);
                },
              );
            }),
            const Divider(),
            Consumer<GetBrachProvider>(
              builder: (context, branchProvider, child) => GestureDetector(
                onTap: () async {
                  await langProvider
                      .changeLanguage(
                          context: context,
                          locale:
                              langProvider.currentLocale == "en" ? "hi" : "en")
                      .then((isSuccess) {
                    if (isSuccess) {
                      /// this is useing for update data in appointment page to update disease id
                      diseaseProvider.resetState(context: context);
                      branchProvider.resetBranchAddressModel(context: context);
                    } else {
                      print("pagination not refreshed");
                    }
                  });
                },
                child: langProvider.isLoading
                    ? const Center(
                        child: Loader(),
                      )
                    : CustomContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        backGroundColor: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(5.w),
                        child: Text(
                          "${langProvider.currentLocale == "en" ? "English" : "Hindi"}",
                          style: TextSizeHelper.smallHeaderStyle,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      {required bool isDoctor,
      required bool isAdmin,
      required LocalizationProvider langProvider,
      required String userName}) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      title: Text(
        isDoctor || isAdmin
            ? _selectedNavTabIndex == 0
                ? "Hello $userName"
                : _selectedNavTabIndex == 1
                    ? navTabNames[0]
                    : _selectedNavTabIndex == 2
                        ? navTabNames[1]
                        : navTabNames[2]
            : langProvider.translate(drawerOptions[_selectedTabIndex]['text']),
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
                  push(context, NotificationsScreen());
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
                  push(context, NotificationsScreen());
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

  const DrawerOptionWidget({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.text,
    required this.onTap,
  });

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
            color: isSelected ? AppColors.greenColor : AppColors.brownColor,
            size: 7.w,
          ),
          title: Text(
            text,
            style: TextSizeHelper.smallHeaderStyle.copyWith(
              color: isSelected ? AppColors.greenColor : AppColors.brownColor,
            ),
          ),
          contentPadding: EdgeInsets.only(right: 0, left: 10.w),
          trailing: isSelected
              ? VerticalDivider(color: AppColors.greenColor, thickness: 10)
              : null,
        ),
      ),
    );
  }
}

/// have used this to render header in drawer
class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({super.key, required this.userName});
  final String userName;

  @override
  State<DrawerHeaderWidget> createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 80.w,
      height: 20.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomContainer(
              borderColor: AppColors.brownColor,
              shape: BoxShape.circle,
              borderWidth: 2,
              child: CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                radius: 10.w,
                child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0] : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextSizeHelper.mediumHeaderStyle),
              ),
            ),
            MethodHelper.heightBox(height: 2.h),
            Text(
              widget.userName,
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
