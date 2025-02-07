import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final PlatformWebViewControllerCreationParams params =
    PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://b2b.exona.kr:11101/Main'));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}





