import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxService {
  final RxList<DummyTokenModel> walletList = RxList.empty();
  final Rx<AssetTokenBalanceListModel> spendingTokens = Rx(AssetTokenBalanceListModel(tokens: []));
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenBalanceModel(), transactions: []));

  @override
  void onInit() {
    getWalletList();
    getSpendingWalletBalances();
    getSpendingWalletTransactions();
    super.onInit();
  }

  void getWalletList() {
    walletList.value = [
      DummyTokenModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }

  void getSpendingWalletBalances() async {
    spendingTokens.value = await WalletService.getSpendingWalletBalance();
    print(spendingTokens.value);
  }

  void getSpendingWalletTransactions() async {
    assetDetail.value = await WalletService.getSpendingWalletTransactions('13');
    print(assetDetail.value);
  }
}
