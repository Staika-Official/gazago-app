import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/webview_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class NoticeWebView extends StatelessWidget {
  const NoticeWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey webViewKey = GlobalKey();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
    );;
  }
}
