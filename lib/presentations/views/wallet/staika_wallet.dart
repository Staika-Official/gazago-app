import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:get/get.dart';

class StaikaWallet extends StatelessWidget {
  const StaikaWallet({Key? key}) : super(key: key);

  // List<Widget> renderCoinAssetList(AssetWalletController controller) {
  //   return controller.coinAssetList
  //       .map(
  //         (asset) => AssetItemCoin(
  //           asset: asset,
  //           onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.asset, assetType: AssetType.coin),
  //         ),
  //       )
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    StaikaWalletController controller = Get.put(StaikaWalletController());

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // ...renderCoinAssetList(controller),
        ],
      ),
    );
  }
}
