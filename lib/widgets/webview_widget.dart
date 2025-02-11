import 'package:flutter/material.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:vaidraj/widgets/custom_container.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.uri});
  final String uri;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool isInit = true;
  bool isPageFailed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            // After the page is loaded, inject JavaScript to hide the header.
            _controller.runJavaScript("""
              // Or if you want to target a specific class or ID:
              var header = document.querySelector('.header_container'); 
              header.style.display = 'none';
            """);
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.uri)).whenComplete(
        () => setState(() {
          isInit = false;
        }),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(backgroundColor: AppColors.whiteColor),
      body: isInit
          ? const Center(
              child: Loader(),
            )
          : isPageFailed
              ? const Center(
                  child: Text('Somthing Went Wrong'),
                )
              : SafeArea(
                  child: CustomContainer(
                      borderRadius: BorderRadius.circular(AppSizes.size10),
                      borderColor: AppColors.brownColor,
                      margin: EdgeInsets.all(AppSizes.size10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.size10),
                          child: WebViewWidget(controller: _controller)))),
    );
  }
}
