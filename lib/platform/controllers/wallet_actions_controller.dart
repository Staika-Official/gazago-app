import 'package:gaza_go/constants/enums.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class WalletActionsController extends GetxController {
  final Rx<WalletActionType> actionType = Rx(WalletActionType.recharge);
  RxString get pageHeader {
    String text = '';
    switch (actionType.value) {
      case WalletActionType.recharge:
        text = 'recharge'.tr();
        break;
      case WalletActionType.sendToInventory:
        text = 'send_to_inventory'.tr();
        break;
      case WalletActionType.sendToAsset:
        text = 'send_to_wallet'.tr();
        break;
      case WalletActionType.sendOutside:
        text = 'send_to_external_wallet'.tr();
        break;
      case WalletActionType.receive:
        text = 'deposit'.tr();
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
      case WalletActionType.receive:
        break;
      case WalletActionType.recharge:
        break;
    }
  }
}
