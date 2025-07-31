import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:easy_localization/easy_localization.dart';

class NoticeWebView extends StatelessWidget {
  const NoticeWebView({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey webViewKey = GlobalKey();
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri('faq_url'.tr())),
          initialSettings: InAppWebViewSettings(
            disableContextMenu: true,
            javaScriptEnabled: true,
            resourceCustomSchemes: ['intent'],
          ),
          onLoadResourceWithCustomScheme: (controller, url) async {
            await controller.stopLoading();
            return null;
          },
          onWebViewCreated: (controller) {
            // register a JavaScript handler with name "myHandlerName"
          },
        ),
      ),
    );
  }
}
