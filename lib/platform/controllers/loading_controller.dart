import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxDouble progress = RxDouble(0);

  @override
  void onInit() {
    ever(progress, (callback) => {if (progress.value == 1) Get.offAllNamed(Routes.home)});
    super.onInit();
  }
}
