import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/solana_mixin.dart';
import 'package:gaza_go/platform/models/charge_tik_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_price_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_token_model.dart';
import 'package:gaza_go/platform/services/solana_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class GoWalletController extends GetxController with SolanaMixin {
  WalletMasterController walletMasterController = Get.find();
  // LoaderController loaderController = Get.find();
  RxList productList = RxList.empty();
  Rx<ChargeTikModel> chargeTikData = Rx(ChargeTikModel(userId: -1, title: "STIK_TO_TIK", fromTokenSymbol: "", fromUiAmount: 0.0, toTokenSymbol: "", toUiAmount: 0, priceKRW: 0.0, priceUSD: 0.0));

  @override
  void onInit() {
    walletMasterController.getStikPriceInfo();
    getProductList();
    super.onInit();
  }

  void exchangeStikToTik(ExchangeStikPriceModel exchangeProduct) async {
    String? userId = HiveStore.loadString(key: HiveKey.userId.name);
    DateTime today = DateTime.now();
    int differenceTime = int.parse(today.difference(DateTime.parse(walletMasterController.stikPriceInfoKRW.value.lastUpdated!)).inSeconds.toString());
    // 현재 시간과 가격정보 받아온 시간이 5분이상 차이나면
    if (differenceTime > 300) {
      failureChargeStikToTikAlert(this, '거래 기준가의 유효시간이 지나 더이상 해당 가격으로\n거래가 불가합니다. 다시 시도해 주시기 바랍니다.');
    } else {
      if (walletMasterController.stik.value.amount! >= double.parse(exchangeProduct.fromUiAmountString!)) {
        // loaderController.isLoading.value = true;
        await SolanaService.fetchChargeStikToTik(
          ChargeTikModel(
            userId: int.parse(userId!),
            title: "STIK_TO_TIK",
            fromTokenSymbol: exchangeProduct.fromTokenSymbol!,
            fromUiAmount: double.parse(exchangeProduct.fromUiAmountString!),
            toTokenSymbol: exchangeProduct.toTokenSymbol!,
            toUiAmount: int.parse(exchangeProduct.toUiAmountString!),
            priceKRW: walletMasterController.stikPriceInfoKRW.value.price!,
            priceUSD: walletMasterController.stikPriceInfoUSD.value.price!,
          ),
          successCallback: (data) {
            successChargeStikToTikAlert(this);
          },
          errorCallback: (err) {
            if (err.status == 500) {
              failureShortBalanceStikToTikAlert(this);
            } else {
              failureChargeStikToTikAlert(this, err.errorMessage);
            }
          },
        );
        // loaderController.isLoading.value = false;
      } else {
        showToastPopup('보유중인 STIK이 충분하지 않습니다.');
      }
    }
  }

  void handleSuccessChargeTik() {
    walletMasterController.getSpendingWalletBalances();
    handleReGetStikPriceAndProductList();
  }

  void handleReGetStikPriceAndProductList() {
    getProductList();
    walletMasterController.getSpendingWalletBalances();
    walletMasterController.getStikPriceInfo();
  }

  Future<void> getProductList() async {
    await SolanaService.getExchangeStikPriceInfo(successCallback: (ExchangeStikTokenModel data) {
      print(data);
      productList.value = data.products;
    });
  }
}
