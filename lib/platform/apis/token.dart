import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class TokenApi {
  static Future<Response> getStikPriceInfo() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/on-chains/quotes/markets/cmc/solana/tokens/STIK');
  }

  static Future<Response> getExchangeStikPriceInfo() async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).get('/tokens/STIK/markets/cmc?platform=solana&transactionTitle=STIK_TO_TIK');
  }
}
