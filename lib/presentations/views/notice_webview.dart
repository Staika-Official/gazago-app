import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
          initialUrlRequest: URLRequest(url: WebUri('https://eztechfin.notion.site/FAQ-2f6b0ec4d6134fd398cd7a832bfa6cd3')),
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
