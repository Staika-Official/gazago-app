import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_inventory_controller.dart';
import 'package:gaza_go/presentations/views/wallet/asset_item_coin.dart';

class WalletInventory extends StatelessWidget {
  const WalletInventory({Key? key}) : super(key: key);

  List<Widget> renderInventoryList(WalletInventoryController controller) {
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
    WalletInventoryController controller = Get.put(WalletInventoryController());
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
