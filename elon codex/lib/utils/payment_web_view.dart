import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class   PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.url,
    this.showTitle = true,
    this.redirectUrl,
    this.onClosed,
    this.onCompleted,
  });
  final String url;
  final bool showTitle;
  final String? redirectUrl;
  final VoidCallback? onClosed;
  final VoidCallback? onCompleted;

  @override
  State<PaymentWebView> createState() => _WebViewState();
}

class _WebViewState extends State<PaymentWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('close',
          onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
        Navigator.of(context).pop(message.message);
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onUrlChange: (url) {
            print('url change $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            final returnUrl = Uri.parse(request.url);
            final status = returnUrl.queryParameters['status'];
            if (status == 'completed') {
              Navigator.of(context).pop();
              widget.onCompleted?.call();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onPopInvoked: (didPop) {
      //   widget.onClosed?.call();
      //     return true;
      // },
      onWillPop: () async {
        widget.onClosed?.call();
        return true;
      },

      // canPop: true,
      // onPopInvokedWithResult: () async {
      //   widget.onClosed?.call();
      //   // return true;
      // },
      child: Scaffold(
        appBar: widget.showTitle
            ? AppBar(
                toolbarHeight: 40,
                leading: IconButton(
                  onPressed: () => widget.onClosed?.call(),
                  icon: const Icon(Icons.close),
                ),
                title: const Text('Top up wallet'),
              )
            : null,
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
