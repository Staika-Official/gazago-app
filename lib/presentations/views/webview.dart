import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/controllers/webview_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
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
        color: webViewController.linkUrl.value.contains('leaderboard')
            ? subBg01Color
            : webViewController.linkUrl.value.contains('taika')
                ? Colors.white
                : const Color(0xFF191919),
        child: SafeArea(
          child: InAppWebView(
            key: webViewController.webViewKey,

            initialUrlRequest: URLRequest(url: WebUri(webViewController.linkUrl.value)),
            initialSettings: InAppWebViewSettings(
              transparentBackground: true,
              javaScriptEnabled: true,
              supportMultipleWindows: true,
              resourceCustomSchemes: ['intent'],
              underPageBackgroundColor: webViewController.linkUrl.value.contains('leaderboard')
                  ? subBg01Color
                  : webViewController.linkUrl.value.contains('taika')
                      ? Colors.white
                      : const Color(0xFF191919),
            ),
            onLoadResourceWithCustomScheme: (controller, url) async {
              await controller.stopLoading();
              return null;
            },

            onWebViewCreated: (controller) async {
              // register a JavaScript handler with name "myHandlerName"
              if (Platform.isAndroid) await InAppWebViewController.setWebContentsDebuggingEnabled(true);
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
              } else {
                controller.addJavaScriptHandler(
                  handlerName: 'app',
                  callback: (args) {
                    // print arguments coming from the JavaScript side!
                    Map result = {};

                    switch (args[0]) {
                      case 'closeWebview':
                        Get.back();
                        break;

                      // case 'getToken':
                      //   String token = HiveStore.loadString(key: HiveKey.accessToken.name)!;
                      //   result = {'appToken': token};
                      //   break;
                      //
                      // case 'refreshBalance':
                      //   walletController.getSpendingWalletBalances();
                      //   break;
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
