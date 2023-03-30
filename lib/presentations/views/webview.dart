import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/webview_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class WebView extends StatelessWidget {
  const WebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = Get.put(WebViewController());
    WalletMasterController walletController = Get.find();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: InAppWebView(
            key: webViewController.webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(webViewController.linkUrl.value)),
            initialSettings: InAppWebViewSettings(
              disableContextMenu: true,
              javaScriptEnabled: true,
            ),
            onWebViewCreated: (controller) {
              // register a JavaScript handler with name "myHandlerName"
              if (webViewController.linkUrl.value.contains('taikapay')) {
                controller.addJavaScriptHandler(
                  handlerName: 'app',
                  callback: (args) {
                    // print arguments coming from the JavaScript side!
                    Map result = {};

                    switch (args[0]) {
                      case 'closeWebview':
                        walletController.getSpendingWalletBalances();
                        Get.back();
                        break;

                      case 'getToken':
                        String token = HiveStore.loadString(key: HiveKey.accessToken.name)!;
                        result = {'appToken': token};
                        break;

                      case 'refreshBalance':
                        walletController.getSpendingWalletBalances();
                        break;
                    }

                    return result;
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
