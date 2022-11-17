import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxController {
  final RxList<AssetTokenBalanceModel> spendingTokens = RxList.empty();
  final RxList<TokenInfoModel> spendingTokenInfoList = RxList.empty();
  final Rx<AssetTokenBalanceUiModel> selectedAsset = Rx(AssetTokenBalanceUiModel());
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenBalanceModel(), transactions: []));
  final Rx<AssetTokenBalanceModel> buyTikCommission = Rx(AssetTokenBalanceModel());
  final RxString buyTikAmount = RxString('0');
  final Rx<BuyTikResponseModel> buyTikResult = Rx(BuyTikResponseModel());
  RxList<AssetTokenBalanceUiModel> get spendingTokenUiList {
    List<AssetTokenBalanceUiModel> balanceUiList = List.empty(growable: true);
    List<AssetTokenBalanceModel> filteredTokenList = spendingTokens.where((token) => token.symbol == 'STIK' || token.symbol == 'TOTAL_TIK').toList();
    for (AssetTokenBalanceModel token in filteredTokenList) {
      AssetTokenBalanceUiModel tokenUi = AssetTokenBalanceUiModel.fromJson(token.toJson());
      TokenInfoModel tokenInfo = spendingTokenInfoList.singleWhere((tokenInfo) => tokenInfo.symbol == token.symbol);
      tokenUi.name = tokenInfo.name;
      tokenUi.logoUrl = tokenInfo.logoUrl;
      tokenUi.price = tokenInfo.price;

      balanceUiList.add(tokenUi);
    }

    return RxList(balanceUiList);
  }

  Rx<AssetTokenBalanceUiModel> get tik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.symbol == 'TOTAL_TIK', orElse: () {
      showToastPopup('TAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceUiModel();
    }));
  }

  Rx<AssetTokenBalanceUiModel> get stik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.symbol == 'STIK', orElse: () {
      showToastPopup('STAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceUiModel();
    }));
  }

  @override
  void onInit() async {
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    super.onInit();
  }

  Future<void> getSpendingWalletBalances() async {
    await WalletService.getSpendingWalletBalance(
      successCallback: (List<AssetTokenBalanceModel> spendingTokens) {
        this.spendingTokens.value = spendingTokens;
      },
    );

    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("서비스를 위해 정보를 불러오는 중입니다.");
  }

  Future<void> getSpendingWalletTransactions(AssetTokenBalanceUiModel asset) async {
    selectedAsset.value = asset;
    assetDetail.value = await WalletService.getSpendingWalletTransactions(asset.accountId!);
  }

  Future<void> getSpendingMetaData() async {
    spendingTokenInfoList.value = await WalletService.getSpendingMetaData();
    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("조금만 기다려주세요");
  }

  Future<void> getBuyTikCommission() async {
    buyTikCommission.value = await WalletService.getBuyTikCommission();
  }

  Future<void> buyTik(int tikAmount) async {
    buyTikResult.value = await WalletService.buyTik(tikAmount);
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    showToastPopup('$tikAmount TIK이 충전되었습니다.');
    Get.until((route) => route.settings.name == Routes.wallet);
  }

  Future<void> payWithToken(PayInfoModel payInfo) async {
    await WalletService.payWithToken(payInfo);
  }

  void moveToWalletDetail({required AssetTokenBalanceUiModel asset, required WalletType walletType, required AssetType assetType}) async {
    await getSpendingWalletTransactions(asset);
    Get.toNamed(Routes.walletDetail, arguments: {'asset': asset, 'walletType': walletType, 'assetType': assetType});
  }

  void toBuyTik() {
    Get.toNamed(Routes.buyTik);
    buyTikAmount.value = '0';
    // buyTikAmountController.text = buyTikAmount.value;
  }

  void enterBuyTikAmount(String tikAmount) {
    // buyTikAmountController.text = tikAmount;
    buyTikAmount.value = tikAmount;
  }

  void showBuyConfirmation(Widget confirmationBottomSheet) {
    Get.bottomSheet(
      confirmationBottomSheet,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }
}
