import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/screens/patient_screen/about_us.dart';
import 'package:vaidraj/screens/patient_screen/appointment.dart';
import 'package:vaidraj/screens/patient_screen/get_in_touch.dart';
import 'package:vaidraj/screens/patient_screen/medical_history.dart';
import 'package:vaidraj/screens/patient_screen/patient_home.dart';
import 'package:vaidraj/screens/patient_screen/products.dart';
import 'package:vaidraj/screens/patient_screen/specialities.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import '../../constants/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isDoctor,
  });
  final bool isDoctor;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  int _selectedNavTabIndex = 0;

  final List<Widget> screensNav = const [
    Screen(number: "Nav 1"),
    Screen(number: "Nav 2"),
    Screen(number: "Nav 3"),
    Screen(number: "Nav 4"),
  ];

  final List<Widget> screensTab = [
    PatientHomeScreen(),
    SpecialitiesScreen(),
    ProductsScreen(),
    Appointment(),
    MedicalHistory(),
    AboutUsScreen(),
    GetInTouchScreen(),
  ];

  final List<Map<String, dynamic>> drawerOptions = [
    {'icon': Icons.home_rounded, 'text': "Home"},
    {'icon': Icons.stars_rounded, 'text': "Specialities"},
    {'icon': Icons.inventory_2_rounded, 'text': "Products"},
    {'icon': Icons.auto_stories_rounded, 'text': "Appointment"},
    {'icon': Icons.medical_information_rounded, 'text': "Medical History"},
    {'icon': Icons.verified_rounded, 'text': "About Us"},
    {'icon': Icons.contact_phone, 'text': "Get In Touch"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      endDrawer: _buildDrawer(),
      appBar: _buildAppBar(isDoctor: widget.isDoctor),
      body: widget.isDoctor
          ? screensNav[_selectedNavTabIndex]
          : screensTab[_selectedTabIndex],
      bottomNavigationBar: widget.isDoctor ? _buildBottomNavigationBar() : null,
    );
  }

  Drawer _buildDrawer() {
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
                icon: drawerOptions[index]['icon'],
                text: drawerOptions[index]['text'],
                isSelected: _selectedTabIndex == index,
                onTap: () {
                  setTabIndexAndCloseDrawer(index);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar({required bool isDoctor}) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      title: Text(
        isDoctor ? "Hello Doctor" : drawerOptions[_selectedTabIndex]['text'],
        style: TextSizeHelper.mediumTextStyle
            .copyWith(color: AppColors.brownColor),
      ),
      leading: isDoctor
          ? Padding(
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
    widget.isDoctor
        ? actions.add(IconButton.filledTonal(
            onPressed: () {},
            style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppColors.backgroundColor)),
            icon: const Icon(Icons.notifications, color: AppColors.brownColor),
          ))
        : _selectedTabIndex != 0
            ? null
            : actions.add(IconButton.filledTonal(
                onPressed: () {},
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.backgroundColor)),
                icon: const Icon(Icons.notifications,
                    color: AppColors.brownColor),
              ));

    if (widget.isDoctor) {
      actions.add(SizedBox(width: 5.w));
    } else {
      actions.add(
          EndDrawerButton(onPressed: _scaffoldKey.currentState?.openEndDrawer));
    }

    return actions;
  }

  /// will build navbar if logged in user is staff member
  ClipRRect _buildBottomNavigationBar() {
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
        destinations: const [
          NavigationDestination(
              selectedIcon:
                  Icon(Icons.home_rounded, color: AppColors.greenColor),
              icon: Icon(Icons.home_rounded, color: AppColors.brownColor),
              label: "Home"),
          NavigationDestination(
              selectedIcon:
                  Icon(Icons.auto_stories_rounded, color: AppColors.greenColor),
              icon:
                  Icon(Icons.auto_stories_rounded, color: AppColors.brownColor),
              label: "Appointments"),
          NavigationDestination(
              selectedIcon: Icon(Icons.personal_injury_rounded,
                  color: AppColors.greenColor),
              icon: Icon(Icons.personal_injury_rounded,
                  color: AppColors.brownColor),
              label: "Patients"),
          NavigationDestination(
              selectedIcon: Icon(Icons.person, color: AppColors.greenColor),
              icon: Icon(Icons.person, color: AppColors.brownColor),
              label: "Account"),
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
class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 80.w,
      height: 25.h,
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
                child: Text("P",
                    overflow: TextOverflow.ellipsis,
                    style: TextSizeHelper.mediumHeaderStyle),
              ),
            ),
            MethodHelper.heightBox(height: 2.h),
            Text(
              "Pruthviraj Sinh",
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
