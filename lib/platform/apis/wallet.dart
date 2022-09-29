import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/client.dart';

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
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).get('//api/spending/wallet/$publicKey/transactions', queryParameters: {
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
  static Future<Response> payWithToken({
    int? recipientId,
    required double tikAmount,
    required PaymentPurpose purpose,
  }) async {
    return await Api.client(serviceUrl: ServiceUrl.spendingWalletService).post('/wallet/buy-tik', data: {
      "recipient": recipientId, //결제 대금을 받을 사용자의 user id (회사가 받는다면, null)
      "amount": {"mint": 1, "amount": tikAmount},
      "fee": {"mint": 2, "amount": 0.0005},
      "label": purpose.label, //enum [ 체력충전, 내구도충전, 아이템수리, 아이템구매, 배지합성, 배지구매, TIK충전 ]
      "memo": ""
    }, queryParameters: {
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
