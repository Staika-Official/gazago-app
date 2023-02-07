import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';

class WalletApi {
  // - 스펜딩 월렛 api
  static Future<Response> getSpendingWalletBalances() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/spending/balances', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingWalletBalance(String symbol) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/spending/balance/$symbol', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingWalletTransactions(String symbol, int size) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/spending/transactions/$symbol', queryParameters: {
      'clientId': 'GAZAGO',
      'size': size,
    });
  }

  static Future<Response> getBuyTikCommission() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/wallet/buy-tik/fee', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> buyTik(int tikAmount) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post(
      '/wallet/buy-tik',
      data: {
        "tikUiAmount": tikAmount,
      },
      queryParameters: {
        'clientId': 'GAZAGO',
      },
    );
  }

  static Future<Response> getFeeTik() async {
    return await Api.client(serviceUrl: '/services/gazago/api/application-environments').get('/fee-tik');
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<Response> payWithToken(PayInfoModel payInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post('/wallet/pay', data: payInfo, queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  // - 외부 월렛 api
  static Future<Response> generateSolanaWallet() async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).post('/gererate-wallet');
  }

  static Future<Response> postEncryptedSecretKey(String publicKey, String encryptedSecretKey) async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).post('/encrypted-secretkey', data: {"publicKey": publicKey, "encryptedSecretKey": encryptedSecretKey});
  }

  static Future<Response> getEncryptedSecretKey() async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).get('/encrypted-secretkey');
  }

  static Future<Response> getSolanaWalletBalance() async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).get('/wallet/balance');
  }

  static Future<Response> getSolanaWalletTransaction(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).get('/wallet/$publicKey/transactions');
  }

  static Future<Response> getTokenMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).get('/token/$publicKey');
  }

  static Future<Response> getNftMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.walletService).get('/nft/$publicKey');
  }
}
