import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';

class WalletApi {
  // - 스펜딩 월렛 api
  static Future<Response> getSpendingWalletBalances() async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/balances', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingTokenBalance(String token) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/balance/$token', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingWalletTransactions(String publicKey, int size) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/wallet/$publicKey/transactions', queryParameters: {
      'clientId': 'GAZAGO',
      'size': size,
    });
  }

  static Future<Response> getBuyTikCommission() async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/wallet/buy-tik/fee', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> buyTik(int tikAmount) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post(
      '/wallet/buy-tik',
      data: {
        "tikUiAmount": tikAmount,
      },
      queryParameters: {
        'clientId': 'GAZAGO',
      },
    );
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<Response> payWithToken(PayInfoModel payInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post('/wallet/pay', data: payInfo, queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingMetaData() async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/tokens', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  static Future<Response> getSpendingMetaDataByItem(String mint) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('/token/$mint', queryParameters: {
      'clientId': 'GAZAGO',
    });
  }

  // - 외부 월렛 api
  static Future<Response> generateSolanaWallet() async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).post('/gererate-wallet');
  }

  static Future<Response> postEncryptedSecretKey(String publicKey, String encryptedSecretKey) async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).post('/encrypted-secretkey', data: {"publicKey": publicKey, "encryptedSecretKey": encryptedSecretKey});
  }

  static Future<Response> getEncryptedSecretKey() async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).get('/encrypted-secretkey');
  }

  static Future<Response> getSolanaWalletBalance() async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).get('/wallet/balance');
  }

  static Future<Response> getSolanaWalletTransaction(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).get('/wallet/$publicKey/transactions');
  }

  static Future<Response> getTokenMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).get('/token/$publicKey');
  }

  static Future<Response> getNftMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.solanaWalletService).get('/nft/$publicKey');
  }
}
