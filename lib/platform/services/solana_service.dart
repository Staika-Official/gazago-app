import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/token.dart';
import 'package:gaza_go/platform/models/exchange_stik_token_model.dart';
import 'package:gaza_go/platform/models/stik_token_model.dart';
import 'package:solana/solana.dart';

class SolanaService {
  createWallet() async {
    Wallet wallet = await Ed25519HDKeyPair.random();
    print(wallet.address);
  }

  static Future<void> getStikPriceInfo({required Function successCallback, Function? errorCallback}) async {
    Response res = await TokenApi.getStikPriceInfo();
    if (res.statusCode == 200) {
      successCallback(StikTokenModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getExchangeStikPriceInfo({required Function successCallback, Function? errorCallback}) async {
    Response res = await TokenApi.getExchangeStikPriceInfo();
    if (res.statusCode == 200) {
      successCallback(ExchangeStikTokenModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
