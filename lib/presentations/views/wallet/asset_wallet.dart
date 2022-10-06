import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_asset_controller.dart';
import 'package:gaza_go/presentations/views/wallet/asset_item_nft.dart';
import 'package:get/get.dart';

class AssetWallet extends StatelessWidget {
  const AssetWallet({Key? key}) : super(key: key);

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

  List<Widget> renderNftAssetList(AssetWalletController controller) {
    return controller.nftAssetList
        .map(
          (asset) => AssetItemNft(
            asset: asset,
            onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.asset, assetType: AssetType.nft),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    AssetWalletController controller = Get.put(AssetWalletController());

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            // ...renderCoinAssetList(controller),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Text(
                'NFT',
                textAlign: TextAlign.start,
              ),
            ),
            ...renderNftAssetList(controller),
          ],
        ),
      ),
    );
  }
}
