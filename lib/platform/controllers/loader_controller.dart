import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class LoaderController extends GetxController {
  RxBool isLoading = RxBool(false);

  @override
  Future<void> onInit() async {
    isLoading.listen((isTrue) {
      if (isTrue) {
        Get.dialog(
          barrierDismissible: false,
          Dialog(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: Center(
              child: SizedBox.square(
                dimension: 32,
                child: CircularProgressIndicator(
                  color:
                      AppColorData.regular().colorIconInteractivePrimaryPressed,
                  backgroundColor: AppColorData.regular()
                      .colorIconInteractivePrimaryPressed
                      .withOpacity(0.2),
                ),
              ),
            ),
          ),
          name: 'progressCircle',
        );
      } else {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        Get.back();
      }
    });
    super.onInit();
  }
}
