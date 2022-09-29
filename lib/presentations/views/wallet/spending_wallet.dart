import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_inventory_controller.dart';
import 'package:gaza_go/presentations/views/wallet/asset_item_coin.dart';
import 'package:get/get.dart';

class SpendingWallet extends StatelessWidget {
  const SpendingWallet({Key? key}) : super(key: key);

  List<Widget> renderInventoryList(SpendingWalletController controller) {
    return controller.inventoryList
        .map(
          (asset) => AssetItemCoin(
            asset: asset,
            onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.inventory, assetType: asset.name == 'taika' ? AssetType.token : AssetType.coin),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    SpendingWalletController controller = Get.put(SpendingWalletController());

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            ...renderInventoryList(controller),
          ],
        ),
      ),
    );
  }
}
