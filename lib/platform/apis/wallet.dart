import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';

class WalletApi {
  static Future<Response> generateSpendingWallet() async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post('/generate-wallet', queryParameters: {
      'client-id': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingWalletBalance() async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/wallet/balance', queryParameters: {
      'client-id': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingWalletTransactions(String publicKey, int size) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/wallet/$publicKey/transactions', queryParameters: {
      'client-id': 'GAZAGO',
      'size': size,
    });
  }

  static Future<Response> buyTik(double tikAmount) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post('/wallet/buy-tik', data: {
      "amountStik": tikAmount,
      "amountTik": tikAmount,
    }, queryParameters: {
      'client-id': 'GAZAGO',
    });
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<Response> payWithToken(PayInfoModel payInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post('/wallet/buy-tik', data: payInfo, queryParameters: {
      'client-id': 'GAZAGO',
    });
  }

  static Future<Response> getTokenMetaData(String publicKey) async {
    return await Api.client(serviceUrl: '/api/solana').get('/token/$publicKey');
  }

  static Future<Response> getNftMetaData(String publicKey) async {
    return await Api.client(serviceUrl: '/api/solana').get('/nft/$publicKey');
  }
}
