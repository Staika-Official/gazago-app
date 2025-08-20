import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class LoaderController extends GetxController {
  RxBool isLoading = RxBool(false);

  @override
  Future<void> onInit() async {
    isLoading.listen((isTrue) {
      if (isTrue) {
        Get.dialog(
          barrierDismissible: false,
          const Dialog(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: skyBlueColor),
              ),
            ),
          ),
          name: 'progressCircle',
        );
      } else {
        Get.back(closeOverlays: true);
      }
    });
    super.onInit();
  }
}
