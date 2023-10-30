import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/solana_mixin.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/charge_tik_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_price_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_quotes_model.dart';
import 'package:gaza_go/platform/models/exchange_stik_token_model.dart';
import 'package:gaza_go/platform/models/on_chain_wallet_model.dart';
import 'package:gaza_go/platform/services/solana_service.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/product_list_dialog.dart';
import 'package:gaza_go/presentations/components/product_list_stik_dialog.dart';
import 'package:get/get.dart';

class GoWalletController extends GetxController with SolanaMixin {
  WalletMasterController walletMasterController = Get.find();
  LoaderController loaderController = Get.find();
  RxList productList = RxList.empty();
  Rx<ChargeTikModel> chargeTikData = Rx(ChargeTikModel(userId: -1, title: "STIK_TO_TIK", fromTokenSymbol: "", fromUiAmount: 0.0, toTokenSymbol: "", toUiAmount: 0, priceKRW: 0.0, priceUSD: 0.0, feeUiAmount:0));
  final FocusNode focusNode = FocusNode();
  final TextEditingController stikAmountTextController = TextEditingController(text: '0');
  final RxString sendStikUiAmount = RxString('0');
  final RxString shortStikUiAmount = RxString('0');
  final RxBool isFetching = RxBool(false);
  Rx<ExchangeStikQuotesModel> stikQuotes = Rx(ExchangeStikQuotesModel(priceKRW: 0.0, priceUSD: 0.0, lastUpdated: ''));

  RxBool get isValid {
    print(sendStikUiAmount.value);
    if (sendStikUiAmount.value != '') {
      return RxBool(double.parse(sendStikUiAmount.value) != 0 && sendStikUiAmount.value != '0.');
    }
    return RxBool(false);
  }


  @override
  void onInit() {
    walletMasterController.getStikPriceInfo();
  initTextController();
    super.onInit();
  }

  void checkShortBalance(ExchangeStikPriceModel item) {
    double fromAmount = walletMasterController.clickedAssetButton.value == 'STAIKA' ? double.parse(item.fromUiAmountString!): productSumFeePrice(item.fromUiAmountString!, item.uiFeeString!);
    double myAssetAmount = double.parse(walletMasterController.clickedAssetButton.value == 'STAIKA' ? walletMasterController.stik.value.uiAmountString! : walletMasterController.exchangeAvailableTik.value.uiAmountString!);

    if( myAssetAmount < fromAmount ){
      failureShortBalanceStikToTikAlert(this);
    } else {
      exchangeStikToTikAlert(this, item);
    }
  }

  void exchangeStikToTik(ExchangeStikPriceModel exchangeProduct) async {
    String? userId = HiveStore.loadString(key: HiveKey.userId.name);
    DateTime today = DateTime.now();
    int differenceTime = int.parse(today.difference(DateTime.parse(walletMasterController.stikPriceInfoKRW.value.lastUpdated!)).inSeconds.toString());
    // 현재 시간과 가격정보 받아온 시간이 5분이상 차이나면
    if (differenceTime > 300) {
      failureChargeStikToTikAlert(this, '거래 기준가의 유효시간이 지나 더이상 해당 가격으로\n거래가 불가합니다. 다시 시도해 주시기 바랍니다.');
    } else {
      String exchangeTitle = walletMasterController.clickedAssetButton.value == 'STAIKA' ? "STIK_TO_TIK" : "TIK_TO_STIK";
      double fromAmount = walletMasterController.clickedAssetButton.value == 'STAIKA' ? double.parse(exchangeProduct.fromUiAmountString!) : productSumFeePrice(exchangeProduct.fromUiAmountString!, exchangeProduct.uiFeeString!);
      double myAssetAmount = walletMasterController.clickedAssetButton.value == 'STAIKA' ? walletMasterController.stik.value.amount! : walletMasterController.tik.value.amount!;

      if (myAssetAmount >= fromAmount) {
        loaderController.isLoading.value = true;
        await SolanaService.fetchChargeStikToTik(
          ChargeTikModel(
            userId: int.parse(userId!),
            title: exchangeTitle,
            fromTokenSymbol: exchangeProduct.fromTokenSymbol!,
            fromUiAmount: double.parse(exchangeProduct.fromUiAmountString!),
            toTokenSymbol: exchangeProduct.toTokenSymbol!,
            toUiAmount: walletMasterController.clickedAssetButton.value == 'STAIKA' ?  double.parse(exchangeProduct.toUiAmountString!): int.parse(exchangeProduct.toUiAmountString!),
            priceKRW: stikQuotes.value.priceKRW!,
            priceUSD: stikQuotes.value.priceUSD!,
            feeUiAmount: int.parse(exchangeProduct.uiFeeString!),
            feeTokenSymbol: int.parse(exchangeProduct.uiFeeString!) > 0 ? 'TIK' : null,
          ),
          successCallback: (data) {
            loaderController.isLoading.value = false;
            successChargeStikToTikAlert(this);
          },
          errorCallback: (err) {
            loaderController.isLoading.value = false;
            if (err.status == 500) {
              failureShortBalanceStikToTikAlert(this);
            } else {
              failureChargeStikToTikAlert(this, err.errorMessage);
            }
          },
        );
      } else {
        if(walletMasterController.clickedAssetButton.value == 'STAIKA'){
          showToastPopup('보유중인 STIK이 충분하지 않습니다.');
        } else {
          showToastPopup('보유중인 TIK이 충분하지 않습니다.');
        }

      }
    }
  }

  void handleSuccessChargeTik() {
    walletMasterController.getSpendingWalletBalances();
    handleReGetStikPriceAndProductList();
  }

  void handleReGetStikPriceAndProductList() async {

    walletMasterController.getSpendingWalletBalances();
    walletMasterController.getStikPriceInfo();
    await getProductList();
  }

  void showProductDialog() async {
    loaderController.isLoading.value = true;
    await getProductList();
    loaderController.isLoading.value = false;
    showProductList();
  }


  void showProductStikDialog(String assetName) async {

    walletMasterController.clickedAssetButton.value = assetName;
    loaderController.isLoading.value = true;
    await getProductList();
    loaderController.isLoading.value = false;
    showProductStikList(assetName);
  }

  void stikSwapWallet() async {
    stikAmountTextController.text = '';
    await getStaikaWalletInfo();
  }

  Future<void> getStaikaWalletInfo() async {
    loaderController.isLoading.value = true;
    initTextController();
    await WalletService.getOnChainWallet(
      successCallback: (OnChainWalletModel data) async {
        loaderController.isLoading.value = false;
        bool isWalletConnectionPrompted = HiveStore.load(key: HiveKey.walletConnectionPrompted.name) ?? false;
        if (!isWalletConnectionPrompted) {
          HiveStore.save(key: HiveKey.walletConnectionPrompted.name, value: true);
          showStaikaStatusAlert(hasWallet: true , tabController: walletMasterController.tabController);
        } else {
          Get.toNamed(Routes.sendStikStaikaWallet);
        }

      },
      errorCallback: (ErrorResponseDataModel data) {
        loaderController.isLoading.value = false;
        // Future.delayed(const Duration(seconds: 3));
        if (data.errorCode == 'WalletNotFoundException') {
          showCreateStaikaWalletAlert();
        } else if (data.errorCode == 'DatabaseErrorException') {
          showToastPopup('잠시 후 다시 시도해 주세요');
        }
      },
    );

  }

  Future<void> getProductList() async {

    if(walletMasterController.clickedAssetButton.value == 'STAIKA'){
      await SolanaService.getExchangeStikPriceInfo(successCallback: (ExchangeStikTokenModel data) {
        print(data);
        stikQuotes.value = data.quotes!;
        productList.value = data.products;
      });
    } else {
      await SolanaService.getExchangeTikPriceInfo(successCallback: (ExchangeStikTokenModel data) {
        print(data);
        stikQuotes.value = data.quotes!;
        productList.value = data.products;
      });
    }
  }

  void setAmount(String changeAmount) {
    sendStikUiAmount.value = changeAmount;
  }

  void openSendStikGoWalletAlert() {
    focusNode.unfocus();
    shortStikUiAmount.value = (double.parse(sendStikUiAmount.value) - double.parse(walletMasterController.stik.value.uiAmountString!)).toString();
    print(double.parse(sendStikUiAmount.value));
    print(double.parse(formatDecimalPlaces(double.parse(walletMasterController.stik.value.uiAmountString!), 4, roundType: RoundType.floor)));
    if (double.parse(sendStikUiAmount.value) <= double.parse(formatDecimalPlaces(double.parse(walletMasterController.stik.value.uiAmountString!), 4, roundType: RoundType.floor))) {
      sendStikToStaikaWalletAlert(this);
    } else {
      sendStikShortBalanceAlert(this);
    }
  }

  void confirmSendStikStaikaWallet() async {
    isFetching.value = true;
    loaderController.isLoading.value = true;
    await WalletService.fetchStikMoveToStaikaWallet(
      symbol: 'STIK',
      amount: double.parse(sendStikUiAmount.value),
      successCallback: (boolean) {
        loaderController.isLoading.value = false;
        successExchangeStikToStaikaWalletAlert(this);
        walletMasterController.getSpendingWalletBalances();
        initTextController();
      },
      errorCallback: (ErrorResponseDataModel error) {
        loaderController.isLoading.value = false;
        if (error.status == 400) {
          showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
        } else {
          failureExchangeStikToGoWalletAlert();
        }
      },
    );
    isFetching.value = false;
    // loaderController.isLoading.value = false;
  }

  void initTextController(){
    focusNode.unfocus();
    sendStikUiAmount.value = '0';
    stikAmountTextController.text = '';
  }

}
