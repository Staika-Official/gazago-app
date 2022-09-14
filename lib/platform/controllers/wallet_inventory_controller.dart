import 'package:get/get.dart';
import 'package:step_go/platform/helpers/wallet_mixin.dart';
import 'package:step_go/platform/models/asset_item_coin_model.dart';

class WalletInventoryController extends GetxController with WalletMixin {
  final RxList<AssetItemCoinModel> inventoryList = RxList.empty();

  @override
  void onInit() {
    getInventoryList();
    super.onInit();
  }

  void getInventoryList() {
    inventoryList.value = [
      AssetItemCoinModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemCoinModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemCoinModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }
}
