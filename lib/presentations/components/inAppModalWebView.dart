import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/platform/controllers/webview_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InAppModalWebView extends StatelessWidget {
  const InAppModalWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? inAppWebViewController;
    WebViewController webViewController = Get.put(WebViewController());

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            title: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.close),
                  onTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        StyledText(
                          webViewController.title.value,
                          letterSpacing: -.1,
                          fontWeight: 600,
                          fontSize: 14,
                          lineHeight: 16,
                          overflowEllipsis: true,
                        ),
                        StyledText(
                          webViewController.linkUrl.value,
                          letterSpacing: -.1,
                          color: lightGrayColor,
                          fontWeight: 500,
                          lineHeight: 14,
                          overflowEllipsis: true,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(Icons.refresh),
                  onTap: () {
                    // webViewController.webViewKey.currentState?.reloadWebView();
                    if (inAppWebViewController != null) {
                      inAppWebViewController!.reload();
                    }
                  },
                ),
              ],
            ),
          ),
          body: InAppWebView(
            key: webViewController.webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(webViewController.linkUrl.value)),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              // setState(() {
              //   this.progress = progress / 100;
              // });
            },
          )),
    );
  }
}
