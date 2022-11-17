import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/pay_response_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';

class WalletService {
  static Future<void> getSpendingWalletBalance({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletBalances();
    if (res.statusCode == 200) {
      List<AssetTokenBalanceModel> tokens = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => tokens.add(AssetTokenBalanceModel.fromJson(item)));
      }

      successCallback(tokens);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<AssetDetailModel> getSpendingWalletTransactions(int accountId, [int size = 10]) async {
    Response res = await WalletApi.getSpendingWalletTransactions(accountId, size);
    return AssetDetailModel.fromJson(res.data);
  }

  static Future<AssetTokenBalanceModel> getBuyTikCommission() async {
    Response res = await WalletApi.getBuyTikCommission();
    return AssetTokenBalanceModel.fromJson(res.data);
  }

  static Future<BuyTikResponseModel> buyTik(int tikAmount) async {
    Response res = await WalletApi.buyTik(tikAmount);
    return BuyTikResponseModel.fromJson(res.data);
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<PayResponseModel> payWithToken(PayInfoModel payInfo) async {
    Response res = await WalletApi.payWithToken(payInfo);
    return PayResponseModel.fromJson(res.data);
  }

  static Future<List<TokenInfoModel>> getSpendingMetaData() async {
    Response res = await WalletApi.getSpendingMetaData();
    List<TokenInfoModel> tokenData = [];
    if (res.data.length > 0) {
      res.data.forEach((item) => tokenData.add(TokenInfoModel.fromJson(item)));
    }
    return tokenData;
  }

  static Future<TokenInfoModel> getSpendingMetaDataByItem(String mint) async {
    Response res = await WalletApi.getSpendingMetaDataByItem(mint);
    return TokenInfoModel.fromJson(res.data);
  }
}
