import 'dart:async';

import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  final RxBool isCreatingWallet = RxBool(true);
  final RxBool isCreationSuccessful = RxBool(false);

  @override
  void onInit() {
    isCreatingWallet.value = true;
    Timer(Duration(seconds: 5), () {
      isCreatingWallet.value = false;
      Timer(Duration(seconds: 5), () {
        isCreationSuccessful.value = true;
      });
    });
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
