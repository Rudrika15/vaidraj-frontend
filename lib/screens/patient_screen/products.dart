import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/strings.dart';
import 'package:vaidraj/models/product_model.dart';
import 'package:vaidraj/provider/localization_provider.dart';
import 'package:vaidraj/services/product_service/product_service.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/color.dart';
import '../../constants/sizes.dart';
import '../../utils/shared_prefs_helper.dart/shared_prefs_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_searchbar.dart';

import '../home/home_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with NavigateHelper {
  ///
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
      child: SafeArea(
          child: Column(
        children: [
          CustomSearchBar(),
          Expanded(
            child: CustomContainer(
              child: Consumer<LocalizationProvider>(
                builder: (context, langProvider, child) => StreamBuilder(
                  stream: langProvider.localeStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Loader(),
                      );
                    } else {
                      bool isEnglish = snapshot.data == "en";
                      return isEnglish
                          ? const RenderProducts()
                          : const RenderProducts();
                    }
                  },
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class RenderProducts extends StatefulWidget {
  const RenderProducts({super.key});

  @override
  State<RenderProducts> createState() => _RenderProductsState();
}

class _RenderProductsState extends State<RenderProducts> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);
  final ProductService service = ProductService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey: pageKey, context: context);
    });
  }

  Future<void> fetchPage(
      {required int pageKey, required BuildContext context}) async {
    try {
      print(pageKey);
      ProductModel? newItems = await service.getProductWithPagination(
        context: context,
        currentPage: pageKey,
      );
      final isLastPage = ((newItems?.data?.data?.length ?? 0) < 5);
      if (isLastPage) {
        _pagingController.appendLastPage(newItems?.data?.data
                ?.where((e) => e.isOnAmazone != "no")
                .toList() ??
            []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            newItems?.data?.data
                    ?.where((e) => e.isOnAmazone != "no")
                    .toList() ??
                [],
            nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
        showNewPageErrorIndicatorAsGridChild: true,
        showNoMoreItemsIndicatorAsGridChild: true,
        showNewPageProgressIndicatorAsGridChild: true,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size20, vertical: AppSizes.size10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.size10,
            mainAxisSpacing: AppSizes.size10),
        shrinkWrap: true,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          noItemsFoundIndicatorBuilder: (context) => CustomContainer(
              alignment: Alignment.center,
              //// will show to let user start controller again
              child: GestureDetector(
                onTap: () async {
                  _pagingController.refresh();
                },
                child: const CustomContainer(
                  shape: BoxShape.circle,
                  child: Icon(
                    Icons.refresh_outlined,
                    color: AppColors.brownColor,
                    size: AppSizes.size40,
                  ),
                ),
              )),
          itemBuilder: (context, item, index) => GestureDetector(
            onTap: () =>
                _launchURL(context: context, url: item.amazonLink ?? ''),
            child: ProductTempletContainer(
              image: "${AppStrings.productPhotoUrl}/${item.thumbnail}",
              productName: item.displayName ?? "",
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }
}

class ProductTempletContainer extends StatelessWidget {
  const ProductTempletContainer(
      {super.key, required this.productName, required this.image});
  final String productName;
  final String image;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 40.w,
      borderColor: AppColors.brownColor,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(AppSizes.size10),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: CustomContainer(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.size10),
                  topRight: Radius.circular(AppSizes.size10)),
              image: MethodHelper.imageOrNoImage(image: image),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    productName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Function to launch the URL
Future<void> _launchURL(
    {required BuildContext context, required String url}) async {
  try {
    // Check if the URL can be launched
    final Uri uri = Uri.parse(url);
    print(uri);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    )) {
      // If URL can't be launched, show an error
      _showErrorDialog(
          context: context,
          message: "Unable to open the link. Please try again later.");
    }
  } catch (e) {
    print(e);
    // Catch any errors that occur
    _showErrorDialog(context: context, message: "An error occurred: $e");
  }
}

// Function to show error dialog
void _showErrorDialog(
    {required BuildContext context, required String message}) {
  // Show an alert dialog with the error message
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
