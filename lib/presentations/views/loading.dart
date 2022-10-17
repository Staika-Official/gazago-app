import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.put(LoadingController());
    Get.put(GlobalController(), permanent: true);
    Get.put(WalletMasterController(), permanent: true);
    Get.put(ActivityController(), permanent: true);

    return DefaultContainer(
      isLeadingShow: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return LinearProgressIndicator(
                  value: loadingController.progress.value,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
