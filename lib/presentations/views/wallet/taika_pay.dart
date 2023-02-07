import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class TaikaPay extends StatelessWidget {
  const TaikaPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletController = Get.find();

    return WillPopScope(
      onWillPop: () async => await walletController.getSpendingWalletBalances().then((value) => true),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: InAppWebView(
              key: walletController.webViewKey,
              // initialUrlRequest: URLRequest(url: WebUri('http://localhost:3000')),
              initialUrlRequest: URLRequest(url: WebUri(F.taikaPayUrl)),
              initialSettings: InAppWebViewSettings(
                disableContextMenu: true,
                javaScriptEnabled: true,
              ),
              onWebViewCreated: (controller) {
                // register a JavaScript handler with name "myHandlerName"
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
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
