import 'package:get/get.dart';
import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/asset_item_coin_model.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';

class WalletAssetController extends GetxController with WalletMixin {
  final RxList<AssetItemCoinModel> coinAssetList = RxList.empty();
  final RxList<AssetItemNftModel> nftAssetList = RxList.empty();

  @override
  void onInit() {
    getAssetList();
    super.onInit();
  }

  void getAssetList() {
    coinAssetList.value = [
      AssetItemCoinModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemCoinModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemCoinModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];

    nftAssetList.value = [
      AssetItemNftModel(name: 'LV.1 만월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 소월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 대월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }
}
