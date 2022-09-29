import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/wallet.dart';

class WalletService {
  static Future<void> generateSpendingWallet() async {
    await WalletApi.generateSpendingWallet();
  }

  static Future<dynamic> getSpendingWalletBalance() async {
    return await WalletApi.getSpendingWalletBalance();
  }

  static Future<dynamic> getSpendingWalletTransactions(String publicKey, [int size = 10]) async {
    return await WalletApi.getSpendingWalletTransactions(publicKey, size);
  }

  static Future<dynamic> buyTik(double tikAmount) async {
    return await WalletApi.buyTik(tikAmount);
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<dynamic> payWithToken({int? recipientId, required double tikAmount, required PaymentPurpose purpose}) async {
    return await WalletApi.payWithToken(recipientId: recipientId, tikAmount: tikAmount, purpose: purpose);
  }
}
