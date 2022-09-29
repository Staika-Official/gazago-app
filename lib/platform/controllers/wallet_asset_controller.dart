import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:get/get.dart';

class AssetWalletController extends GetxController with WalletMixin {
  final RxList<DummyTokenModel> coinAssetList = RxList.empty();
  final RxList<AssetItemNftModel> nftAssetList = RxList.empty();

  @override
  void onInit() {
    getAssetList();
    super.onInit();
  }

  void getAssetList() {
    coinAssetList.value = [
      DummyTokenModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];

    nftAssetList.value = [
      AssetItemNftModel(name: 'LV.1 만월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 소월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 대월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }
}
