import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoaderController extends GetxController {
  final GlobalKey<State<StatefulWidget>> dialogKey = GlobalKey();
  RxBool isLoading = RxBool(false);
  GlobalKey? loaderKey = GlobalKey();

  @override
  void onInit() async {
    isLoading.listen((val) {
      if (val == true) {
        Get.dialog(
            Dialog(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
