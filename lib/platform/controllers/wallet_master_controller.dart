import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';

class WalletMasterController extends GetxService {
  final Rx<AssetTokenBalanceListModel> spendingTokens = Rx(AssetTokenBalanceListModel(tokens: []));

  @override
  void onInit() {
    getSpendingWalletBalances();
    super.onInit();
  }

  void getSpendingWalletBalances() async {
    spendingTokens.value = await WalletService.getSpendingWalletBalance();
    print(spendingTokens.value);
  }
}
