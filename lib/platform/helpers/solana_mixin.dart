import 'package:gaza_go/platform/models/stik_token_model.dart';
import 'package:gaza_go/platform/models/stik_token_quotes_model.dart';
import 'package:gaza_go/platform/services/solana_service.dart';
import 'package:get/get.dart';

class SolanaMixin {
  final Rx<StikTokenModel> stikPriceInfo = Rx(StikTokenModel());
  final Rx<StikTokenQuotesModel> stikPriceInfoKRW = Rx(StikTokenQuotesModel());
  final Rx<StikTokenQuotesModel> stikPriceInfoUSD = Rx(StikTokenQuotesModel());
  // Rx<ExchangeStikTokenModel> productList = Rx(ExchangeStikTokenModel());

  Future<void> getStikPriceInfo() async {
    await SolanaService.getStikPriceInfo(successCallback: (data) {
      stikPriceInfo.value = data;
      stikPriceInfoKRW.value = data.quotes.firstWhere((item) => item.currency == 'KRW');
      stikPriceInfoUSD.value = data.quotes.firstWhere((item) => item.currency == 'USD');
    });
  }
}
