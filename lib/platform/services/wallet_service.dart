import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_list_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';

class WalletService {
  static Future<void> generateSpendingWallet() async {
    await WalletApi.generateSpendingWallet();
  }

  static Future<AssetTokenBalanceListModel> getSpendingWalletBalance() async {
    Response res = await WalletApi.getSpendingWalletBalance();
    return AssetTokenBalanceListModel.fromJson(res.data);
  }

  static Future<AssetDetailModel> getSpendingWalletTransactions(String publicKey, [int size = 10]) async {
    Response res = await WalletApi.getSpendingWalletTransactions(publicKey, size);
    return AssetDetailModel.fromJson(res.data);
  }

  static Future<void> buyTik(double tikAmount) async {
    await WalletApi.buyTik(tikAmount);
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<dynamic> payWithToken(PayInfoModel payInfo) async {
    return await WalletApi.payWithToken(payInfo);
  }
}
