import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/solana_mixin.dart';
import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class StaikaWalletController extends GetxController with WalletMixin, SolanaMixin {
  final RxList<WalletTokenBalanceModel> coinAssetList = RxList.empty();
  final Rx<WalletTokenBalanceModel> assetStik = Rx(WalletTokenBalanceModel());
  final RxList<AssetItemNftModel> nftAssetList = RxList.empty();
  final RxString userWalletAddress = RxString('');
  final Rxn<AnimationController> switchAnimation = Rxn();
  final RxString currentSumPriceUI = RxString('0');
  final RxDouble sendStikAmount = RxDouble(0.0);
  final Rx<Currency> currency = Rx(Currency.krw);
  final TextEditingController stikAmountTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxBool get isKRW {
    return RxBool(currency.value.name == 'krw');
  }

  RxString get currencyString {
    return RxString(currency.value == Currency.krw ? '₩' : '\$');
  }

  @override
  void onInit() async {
    focusNode.addListener(_onFocusChange);
    await getStaikaWalletInfo();
    getStikPriceInfo();
    getOnChainTokenBalance();
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();
    super.onClose();
  }

  void dispose() {
    super.dispose();
    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();
    focusNode.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${focusNode.hasFocus.toString()}");
  }

  getCurrencyPrice(double amount) {
    return (amount * (currency == Currency.krw ? stikPriceInfoKRW.value.price! : stikPriceInfoUSD.value.price!)).toString();
  }

  Future<void> getStaikaWalletInfo() async {
    await WalletService.getOnChainWallet(
      successCallback: (data) {
        userWalletAddress.value = data.publicKey;
        showStaikaStatusAlert(hasWallet: true);
      },
      errorCallback: (ErrorResponseDataModel data) {
        if (data.errorCode == 'WalletNotFoundException') {
          TabController controller = Get.find<WalletMasterController>().tabController;
          showStaikaStatusAlert(hasWallet: false, tabController: controller);
        } else if (data.errorCode == 'DatabaseErrorException') {
          showToastPopup('잠시 후 다시 시도해 주세요');
        }
      },
    );
  }

  void handleCopyWalletAddress() async {
    await Clipboard.setData(ClipboardData(text: userWalletAddress.value));
    showToastPopup('주소가 복사 되었습니다.');
  }

  void onOpenSolScanWallet() {
    Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://solscan.io/account/${userWalletAddress}'});
  }

  void setSwitchValue(bool value) {
    currency.value = value ? Currency.krw : Currency.usd;
    switchAnimation.value?.reset();
    switchAnimation.value?.forward();
  }

  void getOnChainTokenBalance() async {
    await WalletService.getOnChainTokenBalance(successCallback: (tokenData) {
      print(tokenData);
      coinAssetList.value = tokenData;
      assetStik.value = tokenData.firstWhere((data) => data.symbol == 'STIK');

      // setCurrentSumPriceUI(tokenData, currency.value);
      // coinAssetList.add(WalletTokenBalanceModel(symbol: "STIK", name: "Staika", amount: 4998310000, uiAmount: 4.99831));
    });
  }

  void moveToSendToGoWallet() {
    Get.toNamed(Routes.sendStikGoWallet);
  }

  void setAmount(String changeAmount) {
    print(changeAmount);
    sendStikAmount.value = double.parse(changeAmount);
  }
}
