import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';
import 'package:step_go/constants/routes.dart';

class WalletMixin {
  void moveToWalletDetail({required dynamic asset, required WalletType walletType, required AssetType assetType}) {
    Get.toNamed(Routes.walletDetail, arguments: {'asset': asset, 'walletType': walletType, 'assetType': assetType});
  }
}
