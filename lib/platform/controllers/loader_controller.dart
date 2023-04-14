import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/loader.dart';
import 'package:get/get.dart';

class LoaderController extends GetxController {
  final GlobalKey<State<StatefulWidget>> dialogKey = GlobalKey();
  RxBool isLoading = RxBool(false);
  GlobalKey? loaderKey = GlobalKey();

  @override
  void onInit() async {
    isLoading.listen((val) {
      if (val == true) {
        print('열어');
        if (!Get.isDialogOpen!) {
          Get.dialog(Loader(), name: 'progressCircle');
        }
      } else {
        print('닫어');
        Navigator.of(dialogKey.currentContext!).pop();
        // dialogKey.currentState?.pop();
        // Navigator.pop()
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
