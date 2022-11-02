import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';

class WalletDetailController extends GetxController {
  final Rx<dynamic> asset = Rx('');
  final Rx<WalletType> walletType = Rx(WalletType.asset);
  final Rx<AssetType> assetType = Rx(AssetType.token);

  RxBool get isRechargeable {
    return RxBool(walletType.value == WalletType.inventory && assetType.value == AssetType.token);
  }

  RxBool get isInternalTransfer {
    return RxBool(walletType.value == WalletType.inventory && assetType.value == AssetType.coin);
  }

  @override
  void onInit() async {
    asset.value = await Get.arguments['asset'];
    walletType.value = await Get.arguments['walletType'];
    assetType.value = await Get.arguments['assetType'];
    super.onInit();
  }

  void toWalletAction(WalletActionType actionType) {
    Get.toNamed(Routes.walletActions, arguments: {'actionType': actionType});
  }
}
