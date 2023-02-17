import 'dart:io';

import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:gaza_go/platform/models/wallet_solana_model.dart';
import 'package:gaza_go/platform/models/wallet_solana_transfer_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/types/health_status.dart';
import 'package:gaza_go/flavors.dart';
import 'package:url_launcher/url_launcher.dart';

class SolanaController extends GetxController {

  final RxString symbol = RxString('SOL');
  final RxString toAddress = RxString('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');
  final RxDouble uiAmount = RxDouble(0.5);
  final RxString address = RxString('');
  final RxString transaction = RxString('');
  final RxString solscanUrl = RxString('');

  @override
  void onInit() async {
    super.onInit();
  }

  void createWallet() async {
    WalletSolanaModel? wallet = await WalletService.getSolanaWallet();

    // 지갑이 없는 경우에만 등록
    if (wallet == null) {
      // 지갑 패스워드
      String walletPassword = "12345678";
      wallet = await WalletService.createSolanaWallet(walletPassword);
    }
    address.value = wallet.address;
  }

  void sendTransfer() async {
    // Wallet 정보
    WalletSolanaModel? wallet = await WalletService.getSolanaWallet();

    String walletPassword = "12345678";
    String accountSecretkey = wallet!.secretkey;
    String symbol = 'STIKA';
    String tokenAddress = '9TuCLrnSUt2iX6tccPEHSLgUMDg3VpkoEazU5CED3MyX';
    int decimals = 5;
    int amount = (uiAmount.value * 100000000.0).toInt();

    WalletSolanaTransferModel transfer = await WalletService.transferSolana(accountSecretkey, walletPassword, toAddress.value, symbol, tokenAddress, decimals, amount);
    solscanUrl.value = transfer.solscanUrl;
    transaction.value = transfer.signature;
  }

  void launchURL() async {
    final url = solscanUrl.value;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*void sendTransfer(String toAddress, String symbol, String tokenAddress, int decimals, int amount) async {
    await WalletService.sendTransfer(toAddress, symbol, tokenAddress, decimals, amount);
  }*/

  void setSymbol(String? changeSymbol) {
    symbol.value = changeSymbol!;
  }

  void setToAddress(String changeToAddress) {
    toAddress.value = changeToAddress;
  }

  void setAmount(String changeAmount) {
    uiAmount.value = double.parse(changeAmount);
  }
}
