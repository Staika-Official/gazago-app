import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxDouble progress = RxDouble(0);
  final RxString progressMessage = RxString("로드중......");

  @override
  void onInit() {
    if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().onInit();
    if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().onInit();

    super.onInit();
  }

  void updateProgress(String message) {
    progress.value = progress.value + 0.2;
    progressMessage.value = message;

    if (progress.value >= 1) Get.offAllNamed(Routes.home);
  }
}
