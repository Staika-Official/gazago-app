import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/models/token_quotes_model.dart';
import 'package:gaza_go/platform/services/solana_service.dart';
import 'package:get/get.dart';

class SolanaMixin {
  final Rx<TokenModel> stikPriceInfo = Rx(TokenModel());
  final Rx<TokenQuotesModel> stikPriceInfoKRW = Rx(TokenQuotesModel());
  final Rx<TokenQuotesModel> stikPriceInfoUSD = Rx(TokenQuotesModel());
  final RxList<TokenModel> priceInfoList = RxList.empty();
  // Rx<ExchangeStikTokenModel> productList = Rx(ExchangeStikTokenModel());

  Future<void> getStikPriceInfo() async {
    await SolanaService.getStikPriceInfo(successCallback: (data) {
      stikPriceInfo.value = data;
      stikPriceInfoKRW.value = data.quotes.firstWhere((item) => item.currency == 'KRW');
      stikPriceInfoUSD.value = data.quotes.firstWhere((item) => item.currency == 'USD');
    });
  }

  Future<void> getTokenPriceInfoList() async {
    await SolanaService.getTokenPriceInfoList(successCallback: (data) {
      priceInfoList.addAll(data);
    });
  }
}
