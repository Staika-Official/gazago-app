import 'package:get/get.dart';

class TermController extends GetxController {
  final RxString termType = RxString('');

  @override
  void onInit() {
    termType.value = Get.arguments['termType'] ?? '';
    super.onInit();
  }
}
