import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxController {
  final Rx<AssetTokenBalanceListModel> spendingTokens = Rx(AssetTokenBalanceListModel(tokens: []));
  final RxList<TokenInfoModel> spendingTokenInfoList = RxList.empty();
  final Rx<AssetTokenBalanceUiModel> selectedAsset = Rx(AssetTokenBalanceUiModel());
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenBalanceModel(), transactions: []));
  final Rx<AssetTokenBalanceModel> buyTikCommission = Rx(AssetTokenBalanceModel());
  final RxString buyTikAmount = RxString('0');
  final Rx<BuyTikResponseModel> buyTikResult = Rx(BuyTikResponseModel());
  RxList<AssetTokenBalanceUiModel> get spendingTokenUiList {
    List<AssetTokenBalanceUiModel> balanceUiList = List.empty(growable: true);
    for (int i = 0; i < spendingTokens.value.tokens.length; i++) {
      AssetTokenBalanceUiModel tokenUi = AssetTokenBalanceUiModel.fromJson(spendingTokens.value.tokens[i].toJson());
      tokenUi.meta = spendingTokenInfoList[i].meta;
      tokenUi.price = spendingTokenInfoList[i].price;
      balanceUiList.add(tokenUi);
    }
    return RxList(balanceUiList);
  }

  Rx<AssetTokenBalanceUiModel> get tik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.mint == '1', orElse: () {
      Get.snackbar('에러', 'TAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceUiModel();
    }));
  }

  Rx<AssetTokenBalanceUiModel> get stik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.mint == '2', orElse: () {
      Get.snackbar('에러', 'STAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceUiModel();
    }));
  }

  @override
  void onInit() async {
    await getSpendingWalletBalances();
    // await getSpendingMetaData();
    // await getBuyTikCommission();
    super.onInit();
  }

  Future<void> getSpendingWalletBalances() async {
    print('getSpendingWalletBalances');
    spendingTokens.value = await WalletService.getSpendingWalletBalance();
    print(spendingTokens.value);
    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("서비스를 위해 정보를 불러오는 중입니다.");
  }

  Future<void> getSpendingWalletTransactions(AssetTokenBalanceUiModel asset) async {
    selectedAsset.value = asset;
    assetDetail.value = await WalletService.getSpendingWalletTransactions(asset.publicKey!);
  }

  Future<void> getSpendingMetaData() async {
    spendingTokenInfoList.value = await WalletService.getSpendingMetaData();
    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("조금만 기다려주세요ㅊ");
  }

  Future<void> getBuyTikCommission() async {
    buyTikCommission.value = await WalletService.getBuyTikCommission();
    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("서비스를 위해 정보를 불러오는 중입니다.");
  }

  Future<void> buyTik(int tikAmount) async {
    buyTikResult.value = await WalletService.buyTik(tikAmount);
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    Get.snackbar('충전 완료', '$tikAmount Tik이 충전되었습니다.', colorText: Colors.white);
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
