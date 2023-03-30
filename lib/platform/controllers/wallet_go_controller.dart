import 'package:gaza_go/platform/helpers/solana_mixin.dart';
import 'package:gaza_go/platform/services/solana_service.dart';
import 'package:get/get.dart';

class GoWalletController extends GetxController with SolanaMixin {
  RxList productList = RxList.empty();

  @override
  void onInit() {
    getProductList();
    super.onInit();
  }

  void purchaseInAppItem(product) async {
    // showPendingPurchaseUI.value = true;
    // showInAppPurchaseProgressAlert(this);
    try {
      // await InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: product));
    } catch (e) {
      // showPendingPurchaseUI.value = false;
      // showStoreErrorText.value = true;
    }
  }

  Future<void> getProductList() async {
    await SolanaService.getExchangeStikPriceInfo(successCallback: (data) {
      print(data);
      productList.value = data.prices;
    });
  }
}
