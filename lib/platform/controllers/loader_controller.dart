import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class LoaderController extends GetxController {
  GlobalKey<State<StatefulWidget>> dialogKey = GlobalKey();
  RxBool isLoading = RxBool(false);
  GlobalKey? loaderKey = GlobalKey();

  @override
  Future<void> onInit() async {
    isLoading.listen((val) {
      if (val == true) {
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Center(
                child: SizedBox.square(
                  dimension: 32,
                  child: CircularProgressIndicator(
                    color: AppColorData.regular()
                        .colorIconInteractivePrimaryPressed,
                    backgroundColor: AppColorData.regular()
                        .colorIconInteractivePrimaryPressed
                        .withOpacity(0.2),
                  ),
                ),
              ),
            ),
            name: 'progressCircle');
        // if (!Get.isDialogOpen!) {
        //   Get.dialog(Loader(), name: 'progressCircle');
        // }
      } else {
        if (dialogKey.currentContext != null) {
          Navigator.of(dialogKey.currentContext!).pop();
        } else {
          Get.back();
        }

        // dialogKey.currentState?.pop();
        // Navigator.pop()
      }
    });
    super.onInit();
  }
}
