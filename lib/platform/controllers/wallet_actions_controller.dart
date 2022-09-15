import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';

class WalletActionsController extends GetxController {
  final Rx<WalletActionType> actionType = Rx(WalletActionType.recharge);
  RxString get pageHeader {
    String text = '';
    switch (actionType.value) {
      case WalletActionType.recharge:
        text = '충전';
        break;
      case WalletActionType.sendToInventory:
        text = '인벤토리로 보내기';
        break;
      case WalletActionType.sendToAsset:
        text = '지갑으로 보내기';
        break;
      case WalletActionType.sendOutside:
        text = '외부 지갑으로 보내기';
        break;
    }
    return RxString(text);
  }

  @override
  void onInit() {
    actionType.value = Get.arguments['actionType'];
    super.onInit();
  }

  void processAction(double amount) {
    if (actionType.value == WalletActionType.recharge) {
      recharge(amount);
    } else {
      sendAsset(amount);
    }
  }

  void recharge(double amount) {
    //TODO. Do Something
  }

  void sendAsset(double amount) {
    //TODO. Do Something in each case
    switch (actionType.value) {
      case WalletActionType.sendToInventory:
        break;
      case WalletActionType.sendToAsset:
        break;
      case WalletActionType.sendOutside:
        break;
    }
  }
}
