import 'package:flutter/material.dart';
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
          onPageFinished: (String url) {},
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
      body: isInit
          ? const Center(
              child: Loader(),
            )
          : isPageFailed
              ? const Center(child: Text('Somthing Went Wrong'),) 
              : SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }

}
