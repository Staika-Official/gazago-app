import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebViewController extends GetxController {
  final GlobalKey webViewKey = GlobalKey();
  RxString linkUrl = RxString('');

  @override
  void onInit() async {
    initWebViewLinkUrl();
    super.onInit();
  }

  void initWebViewLinkUrl() {
    linkUrl.value = Get.arguments['linkUrl'];
  }
}
