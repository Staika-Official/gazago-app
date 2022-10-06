import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/views/wallet/asset_item_coin.dart';
import 'package:get/get.dart';

class SpendingWallet extends StatelessWidget {
  const SpendingWallet({Key? key}) : super(key: key);

  List<Widget> renderInventoryList(WalletMasterController controller) {
    return controller.spendingTokenUiList
        .map(
          (asset) => AssetItemCoin(
            asset: asset,
            onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.inventory, assetType: asset.meta!.name.toUpperCase() == 'TAIKA' ? AssetType.token : AssetType.coin),
            onTapButton: asset.meta!.name.toUpperCase() == 'TAIKA' ? () => controller.toBuyTik() : null,
            buttonText: asset.meta!.name.toUpperCase() == 'TAIKA' ? '충전' : null,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController controller = Get.find();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        child: Obx(() {
          return Column(
            children: [
              ...renderInventoryList(controller),
            ],
          );
        }),
      ),
    );
  }
}
