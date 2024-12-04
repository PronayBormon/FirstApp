import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HtmlPage extends StatefulWidget {
  const HtmlPage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HtmlPage> {
  late InAppWebViewController _webViewController;
  late InAppWebView _webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
              "https://m.pgf-aspb7a-test.cc/?or=static.pgf-aspb7a-test.cc&btt=1&op=1727060615&ah=api-test&sip=https://api.pgsoft-games-test.cc&gi=1786529&ot=4ae1-6d64-0b57-414e-87da&cid=0&ops=luck_single_771&l=en&oc=0&n=ayesha&ct=INR"), // Use WebUri instead of Uri
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStart: (InAppWebViewController controller, WebUri? url) {
          print("Page Started: $url");
        },
        onLoadStop: (InAppWebViewController controller, WebUri? url) async {
          print("Page Loaded: $url");
        },
      ),
    );
  }
}
