import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/constants/enums.dart';
import 'package:step_go/platform/controllers/wallet_asset_controller.dart';
import 'package:step_go/presentations/views/wallet/asset_item_coin.dart';
import 'package:step_go/presentations/views/wallet/asset_item_nft.dart';

class WalletAssets extends StatelessWidget {
  const WalletAssets({Key? key}) : super(key: key);

  List<Widget> renderCoinAssetList(WalletAssetController controller) {
    return controller.coinAssetList
        .map(
          (asset) => AssetItemCoin(
            asset: asset,
            onTap: () => controller.moveToWalletDetail(asset: asset, walletType: WalletType.asset, assetType: AssetType.coin),
          ),
        )
        .toList();
  }

  List<Widget> renderNftAssetList(WalletAssetController controller) {
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
    WalletAssetController controller = Get.put(WalletAssetController());

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            ...renderCoinAssetList(controller),
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
