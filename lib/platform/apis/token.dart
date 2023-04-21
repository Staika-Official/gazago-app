import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/charge_tik_model.dart';

class TokenApi {
  static Future<Response> getStikPriceInfo() async {
    return await Api.client(
      serviceUrl: ServiceUrl.goWalletService,
      showLoading: false,
    ).get('/on-chains/quotes/markets/cmc/solana/tokens/STIK');
  }

  static Future<Response> getExchangeStikPriceInfo() async {
    return await Api.client(
      serviceUrl: ServiceUrl.goWalletService,
      showLoading: false,
    ).get('/spending/tokens/swap?action=STIK_TO_TIK&markets=cmc');
  }

  static Future<Response> fetchChargeStikToTik(
    ChargeTikModel chargeData,
    String userId,
  ) async {
    return await Api.client(serviceUrl: ServiceUrl.goWalletService).post('/spending/tokens/swap?clientId=GAZAGO', data: chargeData);
  }
}
