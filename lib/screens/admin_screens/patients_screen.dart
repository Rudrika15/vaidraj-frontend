import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/models/my_patients_model.dart';
import 'package:vaidraj/provider/get_brach_provider.dart';
import 'package:vaidraj/services/my_patient_service/my_patient_service.dart';
import 'package:vaidraj/utils/border_helper/border_helper.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/custom_dropdown.dart';
import 'package:vaidraj/widgets/custom_searchbar.dart';
import '../../provider/my_patients_provider.dart';
import '../../widgets/loader.dart';
import '../../widgets/primary_btn.dart';
import '../home/home_screen.dart';
import 'patients_history.dart';

class AdminPatientsScreen extends StatefulWidget {
  const AdminPatientsScreen({
    super.key,
  });

  @override
  State<AdminPatientsScreen> createState() => _AdminPatientsScreenState();
}

class _AdminPatientsScreenState extends State<AdminPatientsScreen>
    with NavigateHelper {
  String? role;
  bool isLoading = false;
  String? branchId;
  String searchQuery = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var patientProvider =
        Provider.of<MyPatientsProvider>(context, listen: false);
    var branchProvider = Provider.of<GetBrachProvider>(context, listen: false);
    loadRole();
    patientProvider.initBranchId();
    patientProvider.initPaginController(context: context);
    patientProvider.pagingController.refresh();
    if (mounted) {
      branchProvider.getBranch(context: context);
    }
  }

  Future<void> loadRole() async {
    role = await SharedPrefs.getRole();

    if (role == "doctor" || role == "manager") {
      String s = await SharedPrefs.getBranchId();
      setState(() {
        branchId = s;
      });
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
              screenIndex: 1,
            ));
      },
      child: Consumer2<GetBrachProvider, MyPatientsProvider>(
        builder: (context, brachProvider, myPatientProvider, child) =>
            RefreshIndicator(
          onRefresh: () async {
            loadRole();
            myPatientProvider.pagingController.refresh();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                  onSubmitted: (value) => setState(() {
                        myPatientProvider.setSearchQuery = value;
                      })),
              if (role == "admin")
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    brachProvider.isLoading
                        ? const Center(
                            child: Loader(),
                          )
                        : CustomDropDownWidget(
                            hintText: "Select Branch",
                            // value: myPatientProvider.branchId,
                            decoration: BorderHelper.dropDownOutlinedBorder(
                                suffixIcon: Icons.keyboard_arrow_down),
                            items: brachProvider
                                        .getBranchModel?.data?.isNotEmpty ==
                                    true
                                ? List<DropdownMenuItem<Object?>>.generate(
                                    brachProvider
                                            .getBranchModel?.data?.length ??
                                        0,
                                    (index) {
                                      return DropdownMenuItem(
                                        value: brachProvider.getBranchModel
                                                ?.data?[index].id ??
                                            "-",
                                        child: Text(
                                          brachProvider.getBranchModel
                                                  ?.data?[index].branchName ??
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
                                        "No Branch Found",
                                        style: TextSizeHelper.smallHeaderStyle,
                                      ),
                                    )
                                  ],
                            onChanged: (value) {
                              myPatientProvider.setBranchId = value.toString();
                              myPatientProvider.pagingController.refresh();
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please select Disease !!";
                              }
                              return null;
                            },
                          ),
                    MethodHelper.widthBox(width: 5.w)
                  ],
                ),
              Expanded(
                child: PagedListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          endIndent: 5.w,
                          indent: 5.w,
                          height: 2.h,
                        ),
                    shrinkWrap: true,
                    pagingController: myPatientProvider.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<PatientsInfo>(
                      noItemsFoundIndicatorBuilder: (context) => SizedBox(
                        height: 60.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No Patients Found",
                                style: TextSizeHelper.smallHeaderStyle
                                    .copyWith(color: AppColors.brownColor),
                              ),
                              MethodHelper.heightBox(height: 5.h),
                              SizedBox(
                                height: 5.h,
                                width: 25.w,
                                child: PrimaryBtn(
                                    btnText: "Refresh",
                                    textStyle: TextSizeHelper.smallTextStyle
                                        .copyWith(color: AppColors.whiteColor),
                                    onTap: () async {
                                      print("clicked");
                                      myPatientProvider.pagingController
                                          .refresh();
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, index) {
                        // print(item.appointment?.userId);
                        return MyPatientsListTile(
                            userId: item.appointment?.userId ?? 0,
                            contactNumber: item.appointment?.contact ?? "",
                            role: role,
                            name: item.appointment?.name ?? "");
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyPatientsListTile extends StatelessWidget with NavigateHelper {
  const MyPatientsListTile({
    super.key,
    required this.userId,
    required this.role,
    required this.name,
    required this.contactNumber,
  });
  final int userId;
  final String? role;
  final String name;
  final String contactNumber;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.backgroundColor,
        maxRadius: AppSizes.size30,
        child: Text(MethodHelper.getInitials(name: name)),
      ),
      title: Text(
        name,
        style: TextSizeHelper.smallHeaderStyle
            .copyWith(color: AppColors.brownColor),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: role == "admin" || role == "manager"
          ? Text(
              contactNumber,
              style: TextSizeHelper.smallTextStyle,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: GestureDetector(
        onTap: () => push(
            context,
            PatientsHistoryScreen(
              id: userId,
              name: name,
            )),
        child: CustomContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size10, vertical: 5),
          backGroundColor: AppColors.lightBackGroundColor,
          borderColor: AppColors.brownColor,
          borderWidth: 0.3,
          borderRadius: BorderRadius.circular(AppSizes.size30),
          child: Text(
            "History",
            style: TextSizeHelper.smallTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
