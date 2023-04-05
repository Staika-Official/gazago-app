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

  static Future<Response> getEncryptedSecretKey() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/solana/encrypted-secretkey');
  }

  static Future<Response> getSolanaWalletBalance() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/wallet/balance');
  }

  static Future<Response> getSolanaWalletTransaction(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/wallet/$publicKey/transactions');
  }

  static Future<Response> getTokenMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/token/$publicKey');
  }

  static Future<Response> getNftMetaData(String publicKey) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/nft/$publicKey');
  }

  static Future<Response> getSolanaWallet(String? userId) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/solana/wallet/$userId');
  }

  static Future<Response> createSolanaWallet(String publicKey, String encryptedSecretKey) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post('/solana/wallet', data: {"publicKey": publicKey, "encryptedSecretKey": encryptedSecretKey});
  }

  static Future<Response> transferSolana(Map<String, String> body) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post('/solana/transfer', data: body);
  }

  //onchain apis
  static Future<Response> getOnChainWallet(String? userId) async {
    return await Api.client(serviceUrl: ServiceUrl.onChainWalletService, allowCustomErrorHandler: true).get('/wallets/users/$userId');
  }

  //onchain apis
  static Future<Response> createOnChainWallet(String? userId, {required String publicKey, required String secretKey}) async {
    return await Api.client(serviceUrl: ServiceUrl.onChainWalletService).post('/wallets/users/$userId');
  }

  //onchain apis
  static Future<Response> getOnChainTokenBalance(String? userId) async {
    return await Api.client(serviceUrl: ServiceUrl.onChainWalletService, allowCustomErrorHandler: true).get('/users/$userId/balances');
  }
}
