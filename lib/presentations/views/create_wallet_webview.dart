import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class CreateWalletWebview extends StatelessWidget {
  const CreateWalletWebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 한국이 아닌 경우 본인인증 없이 지갑 생성
    String languageCode = isKoreaRegion() ? 'ko-KR' : 'en-US';

    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri('${F.webWalletUrl}/terms?hl=$languageCode&ci=GAZAGO')),
        initialSettings: InAppWebViewSettings(
          clearCache: true,
          transparentBackground: false,
          javaScriptEnabled: true,
          supportMultipleWindows: true,
          resourceCustomSchemes: ['intent'],
          underPageBackgroundColor: Colors.white,
          isInspectable: true,
        ),
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
        onLoadResourceWithCustomScheme: (controller, url) async {
          await controller.stopLoading();
          return null;
        },
        onWebViewCreated: (controller) async {
          if (Platform.isAndroid)
            await InAppWebViewController.setWebContentsDebuggingEnabled(true);
          controller.addJavaScriptHandler(
            handlerName: 'app',
            callback: (args) async {
              // print arguments coming from the JavaScript side!
              Map result = {};

              switch (args[0]) {
                case 'CLOSE_WEBVIEW':
                  // Get.find<WalletMasterController>().tabController.animateTo(0);
                  Get.back();
                  break;

                case 'REQUEST_TOKEN':
                  String accessToken =
                      HiveStore.loadString(key: HiveKey.accessToken.name)!;
                  controller.evaluateJavascript(
                      source: "window.setToken('$accessToken')");
                  break;

                case 'COPY_ADDRESS':
                  await Clipboard.setData(ClipboardData(text: args[1]));
                  break;

                case 'CREATION_SUCCESSFUL':
                  if (Get.isRegistered<StaikaWalletController>()) {
                    await Get.find<StaikaWalletController>()
                        .getStaikaWalletInfo();
                  }
                  Get.until((route) =>
                      Get.currentRoute == Routes.wallet ||
                      Get.currentRoute == Routes.itemDetail);
                  break;

                case 'VERIFICATION_REQUIRED':
                  // 한국이 아닌 경우 본인인증 우회
                  if (!isKoreaRegion()) {
                    print('Non-Korean user, bypassing verification');
                    // 본인인증 완료 상태로 처리
                    controller.evaluateJavascript(
                        source: "window.completeVerification()");
                  }
                  break;
              }

              return result;
            },
          );
        },
      ),
    );
  }
}
