import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';

class WalletActionsController extends GetxController {
  final Rx<WalletActionType> actionType = Rx(WalletActionType.recharge);

  @override
  void onInit() {
    actionType.value = Get.arguments['actionType'];
    super.onInit();
  }
}
