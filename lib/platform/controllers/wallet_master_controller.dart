import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxService {
  final RxList<DummyTokenModel> walletList = RxList.empty();
  final RxList<AssetTokenBalanceUiModel> spendingTokenUiList = RxList.empty();
  final Rx<AssetTokenBalanceListModel> spendingTokens = Rx(AssetTokenBalanceListModel(tokens: []));
  final Rx<AssetTokenBalanceUiModel> selectedAsset = Rx(AssetTokenBalanceUiModel());
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenBalanceModel(), transactions: []));

  @override
  void onInit() async {
    getWalletList();
    await getSpendingWalletBalances();
    await getSpendingMetaData();
    super.onInit();
  }

  void getWalletList() {
    walletList.value = [
      DummyTokenModel(name: 'go', balance: 100.00, tokenImageUrl: 'assets/images/ico_token_go.svg'),
      DummyTokenModel(name: 'tik', balance: 10.00, tokenImageUrl: 'assets/images/ico_token_tik.svg'),
      DummyTokenModel(name: 'staika', balance: 1000.00, tokenImageUrl: 'assets/images/ico_token_staika.svg'),
    ];
  }

  Future<void> getSpendingWalletBalances() async {
    spendingTokens.value = await WalletService.getSpendingWalletBalance();
    for (AssetTokenBalanceModel token in spendingTokens.value.tokens) {
      AssetTokenBalanceUiModel uiModel = AssetTokenBalanceUiModel.fromJson(token.toJson());
      spendingTokenUiList.add(uiModel);
    }
  }

  Future<void> getSpendingWalletTransactions(AssetTokenBalanceUiModel asset) async {
    selectedAsset.value = asset;
    assetDetail.value = await WalletService.getSpendingWalletTransactions(asset.publicKey!);
  }

  Future<void> getSpendingMetaData() async {
    for (AssetTokenBalanceUiModel token in spendingTokenUiList) {
      TokenInfoModel tokenMetaData = await WalletService.getSpendingMetaData(token.mint!);
      token.meta = tokenMetaData.meta;
      token.price = tokenMetaData.price;
      print(token.toJson());
    }
  }

  Future<void> buyTik(int tikAmount) async {
    await WalletService.buyTik(tikAmount);
  }

  Future<void> payWithToken(PayInfoModel payInfo) async {
    await WalletService.payWithToken(payInfo);
  }

  void moveToWalletDetail({required AssetTokenBalanceUiModel asset, required WalletType walletType, required AssetType assetType}) async {
    await getSpendingWalletTransactions(asset);
    Get.toNamed(Routes.walletDetail, arguments: {'asset': asset, 'walletType': walletType, 'assetType': assetType});
  }

  void toBuyTik() {
    print('buy tik');
  }
}
