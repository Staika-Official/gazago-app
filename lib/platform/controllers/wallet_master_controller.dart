import 'package:flutter/cupertino.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxService {
  final RxList<DummyTokenModel> walletList = RxList.empty();
  final Rx<AssetTokenBalanceListModel> spendingTokens = Rx(AssetTokenBalanceListModel(tokens: []));
  final RxList<TokenInfoModel> spendingTokenInfoList = RxList.empty();
  final Rx<AssetTokenBalanceUiModel> selectedAsset = Rx(AssetTokenBalanceUiModel());
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenBalanceModel(), transactions: []));
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

  @override
  void onInit() async {
    getWalletList();
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    super.onInit();
  }

  void getWalletList() {
    walletList.value = [
      DummyTokenModel(name: 'go', balance: 100.00, tokenImageUrl: 'assets/images/common/ico_token_go.svg'),
      DummyTokenModel(name: 'tik', balance: 10.00, tokenImageUrl: 'assets/images/common/ico_token_tik.svg'),
      DummyTokenModel(name: 'staika', balance: 1000.00, tokenImageUrl: 'assets/images/common/ico_token_staika.svg'),
    ];
  }

  Future<void> getSpendingWalletBalances() async {
    spendingTokens.value = await WalletService.getSpendingWalletBalance();
  }

  Future<void> getSpendingWalletTransactions(AssetTokenBalanceUiModel asset) async {
    selectedAsset.value = asset;
    assetDetail.value = await WalletService.getSpendingWalletTransactions(asset.publicKey!);
  }

  Future<void> getSpendingMetaData() async {
    List<TokenInfoModel> tokenInfoList = List.empty(growable: true);
    for (AssetTokenBalanceModel token in spendingTokens.value.tokens) {
      TokenInfoModel tokenMetaData = await WalletService.getSpendingMetaData(token.mint!);
      tokenInfoList.add(tokenMetaData);
    }

    spendingTokenInfoList.value = tokenInfoList;
  }

  Future<void> buyTik(int tikAmount) async {
    buyTikResult.value = await WalletService.buyTik(tikAmount);
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    Get.snackbar(
      '충전 완료',
      '$tikAmount Tik이 충전되었습니다.',
    );
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
    );
  }
}
