import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/solana_mixin.dart';
import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/on_chain_wallet_model.dart';
import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/models/token_quotes_model.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/views/wallet/confirm_wallet_password.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';

class StaikaWalletController extends GetxController with WalletMixin, SolanaMixin {
  LoaderController loaderController = Get.put(LoaderController());
  WalletMasterController walletMasterController = Get.find();
  final RxList<WalletTokenBalanceModel> coinAssetList = RxList.empty();
  final Rxn<WalletTokenBalanceModel> assetStik = Rxn();
  final RxList<AssetItemNftModel> nftAssetList = RxList.empty();
  final RxString userWalletAddress = RxString('');
  final RxString explorerUrl = RxString('');
  final Rxn<AnimationController> switchAnimation = Rxn();
  final RxString currentSumPriceUI = RxString('0');
  RxString sendStikUiAmount = RxString('0');
  final RxString shortStikUiAmount = RxString('0');
  final RxDouble fee = RxDouble(0.0);
  final Rx<Currency> currency = Rx(Currency.krw);
  final TextEditingController stikAmountTextController = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();
  final RxBool isFetching = RxBool(false);
  final RxString userEmail = RxString('');

  RxBool get isValid {
    if (sendStikUiAmount.value != '') {
      return RxBool(double.parse(sendStikUiAmount.value) != 0 && sendStikUiAmount.value != '0.');
    }
    return RxBool(false);
  }

  RxBool get isKRW {
    return RxBool(currency.value.name == 'krw');
  }

  RxString get currencyString {
    return RxString(currency.value == Currency.krw ? '₩' : '\$');
  }

  @override
  void onInit() async {
    focusNode.addListener(_onFocusChange);
    userEmail.value = await HiveStore.load(key: HiveKey.email.name) ?? '';
    await getStaikaWalletInfo();

    super.onInit();
  }

  @override
  void onClose() async {
    walletMasterController.tabController.animateTo(0);
    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();

    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();
    focusNode.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${focusNode.hasFocus.toString()}");
  }

  String getCurrencyPrice(TokenModel token, double amount) {
    TokenQuotesModel quote = token.quotes!.singleWhere((quote) => quote.currency! == (currency.value == Currency.krw ? 'KRW' : 'USD'));
    double price = quote.price!;

    return (amount * price).toString();
  }

  Future<void> getStaikaWalletInfo() async {
    // HiveStore.save(key: HiveKey.onChainWalletRequestTime.name, value: false);
    await WalletService.getOnChainWallet(
      successCallback: (OnChainWalletModel data) async {
        HiveStore.save(key: HiveKey.solanaSecretKey.name, value: data.secretKey);
        userWalletAddress.value = data.publicKey;
        explorerUrl.value = data.explorerUrl;
        print(HiveStore.load(key: HiveKey.walletConnectionPrompted.name));
        bool isWalletConnectionPrompted = HiveStore.load(key: HiveKey.walletConnectionPrompted.name) ?? false;
        if (!isWalletConnectionPrompted) {
          HiveStore.save(key: HiveKey.walletConnectionPrompted.name, value: true);
          showStaikaStatusAlert(hasWallet: true);
        }
        await getStikPriceInfo();
        await getTokenPriceInfoList();
        await getOnChainTokenBalance();
      },
      errorCallback: (ErrorResponseDataModel data) {
        if (data.errorCode == 'NOT_FOUND_WALLET') {
          TabController controller = Get.find<WalletMasterController>().tabController;
          showStaikaStatusAlert(hasWallet: false, tabController: controller);
        } else if (data.errorCode == 'NOT_SUPPORT_WALLET') {
          TabController controller = Get.find<WalletMasterController>().tabController;
          showNotSupportedWalletAlert(message: data.errorMessage!, tabController: controller);
        } else if (data.errorCode == 'DATABASE_EXCEPTION') {
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
    Get.toNamed(Routes.webView, arguments: {'linkUrl': explorerUrl.value});
  }

  void setSwitchValue(bool value) {
    currency.value = value ? Currency.krw : Currency.usd;
    switchAnimation.value?.reset();
    switchAnimation.value?.forward();
  }

  Future<void> getOnChainTokenBalance() async {
    HiveStore.save(key: HiveKey.onGetChainWalletBalanceTime.name, value: DateTime.now().toString());
    isFetching.value = true;
    initTextController();
    await WalletService.getOnChainTokenBalance(successCallback: (List<WalletTokenBalanceModel> tokenData) {
      coinAssetList.clear();
      coinAssetList.addAll(tokenData);
      try {
        assetStik.value = tokenData.singleWhere((data) => data.symbol == 'STIK');
      } catch (e) {
        assetStik.value = null;
      }
    });
    isFetching.value = false;
  }

  void stikSwapWallet() {
    initTextController();
    Get.toNamed(Routes.sendStikGoWallet);
  }

  void setAmount(String changeAmount) {
    sendStikUiAmount.value = changeAmount;
  }

  void openSendStikGoWalletAlert() async {
    shortStikUiAmount.value = (double.parse(assetStik.value!.uiAmountString) - double.parse(sendStikUiAmount.value)).toString();
    if (double.parse(sendStikUiAmount.value) < double.parse(assetStik.value!.uiAmountString)) {
      if (double.parse(sendStikUiAmount.value) < 1) {
        showMinimumSendStikAmountAlert();
        return;
      }
      focusNode.unfocus();
      String password = await showConfirmPasswordDialog(walletMasterController);
      sendStikToGoWalletAlert(this, password);
    } else {
      exchangeStikShortBalanceAlert(this);
    }
  }

  void confirmSendStikToGoWallet(String password) async {
    String secretKey = HiveStore.load(key: HiveKey.solanaSecretKey.name);
    late final Ed25519HDPublicKey solanaTokenMasterWallet;
    await WalletService.getWalletAddress(
      'SOLANA_GAZAGO_WALLET',
      successCallback: (address) {
        solanaTokenMasterWallet = Ed25519HDPublicKey.fromBase58(address[0].value);
      },
    );
    num mod = pow(10.0, 9);
    if (double.parse(sendStikUiAmount.value) < double.parse(assetStik.value!.uiAmountString)) {
      isFetching.value = true;
      loaderController.isLoading.value = true;
      await WalletService.fetchStikMoveToGoWallet(
        symbol: 'STIK',
        accountSecretkey: secretKey,
        walletPassword: password,
        // 회사 계정 지갑
        toAddress: solanaTokenMasterWallet,
        // 토큰 민트 주소
        tokenAddress: F.solanaTokenMint,
        decimals: assetStik.value!.decimals,
        amount: (double.parse(sendStikUiAmount.value) * mod).toInt(),
        successCallback: (boolean) {
          loaderController.isLoading.value = false;
          successExchangeStikToGoWalletAlert(this);
          walletMasterController.getSpendingWalletBalances();
          initTextController();
          // Get.offNamedUntil(Routes.wallet);
        },
        errorCallback: (error) {
          loaderController.isLoading.value = false;
          failureExchangeStikToGoWalletAlert();
          walletMasterController.getSpendingWalletBalances();
          initTextController();
        },
      );
      isFetching.value = false;
      // loaderController.isLoading.value = false;
    }
  }

  void initTextController() {
    focusNode.unfocus();
    sendStikUiAmount.value = '0';
    stikAmountTextController.text = '';
  }
}
