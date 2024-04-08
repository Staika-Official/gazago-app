import 'package:flutter/material.dart';
import 'package:gaza_go/constants/events.dart';
import 'package:get/get.dart';
import 'package:get_event_bus/get_event_bus.dart';

class WebViewController extends GetxController {
  GlobalKey webViewKey = GlobalKey();
  RxString linkUrl = RxString('');
  RxString title = RxString('');

  @override
  void onInit() async {
    initWebViewLinkUrl();
    super.onInit();
  }

  @override
  void onClose() async {
    if (linkUrl.value.contains('taikapay')) {
      Get.bus.fire(GetSpendingWalletBalancesEvent());
    }
    super.onClose();
  }

  void initWebViewLinkUrl() {
    linkUrl.value = Get.arguments['linkUrl'] ?? '';
    title.value = Get.arguments['title'] ?? '';
  }
}
