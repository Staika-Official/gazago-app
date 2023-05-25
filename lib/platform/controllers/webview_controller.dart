import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:get/get.dart';

class WebViewController extends GetxController {
  GlobalKey webViewKey = GlobalKey();
  RxString linkUrl = RxString('');
  WalletMasterController walletController = Get.find();

  @override
  void onInit() async {
    initWebViewLinkUrl();
    super.onInit();
  }

  @override
  void onClose() async {
    if (linkUrl.value.contains('taikapay')) {
      await walletController.getSpendingWalletBalances();
    }
    super.onClose();
  }

  void initWebViewLinkUrl() {
    print(Get.arguments['linkUrl']);
    linkUrl.value = Get.arguments['linkUrl'];
  }
}
