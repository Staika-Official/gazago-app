import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:get/get.dart';

class GoWalletController extends GetxController with WalletMixin {
  final RxList<DummyTokenModel> inventoryList = RxList.empty();

  @override
  void onInit() {
    getInventoryList();
    super.onInit();
  }

  void getInventoryList() {
    inventoryList.value = [
      DummyTokenModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }
}
