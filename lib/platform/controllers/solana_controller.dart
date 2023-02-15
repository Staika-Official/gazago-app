import 'dart:io';

import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/types/health_status.dart';
import 'package:gaza_go/flavors.dart';

class SolanaController extends GetxController {

  final RxString symbol = RxString('SOL');
  final RxString toAddress = RxString('');
  final RxInt uiAmount = RxInt(0);

  @override
  void onInit() async {
    super.onInit();
  }

  void createWallet() async {
    // 지갑 패스워드
    String walletPassword = "12345678";
    await WalletService.createSolanaWallet(walletPassword);

  }

  void sendTransfer() async {
    // Wallet 정보

    String walletPassword = "12345678";
    String accountPrivateKey = 'Br4N3pMn2hjk2P685bN99FTYojhSuiRPUiz1YffX81HV';
    String toAddress = '4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1';
    String symbol = 'STIKA';
    String tokenAddress = '9TuCLrnSUt2iX6tccPEHSLgUMDg3VpkoEazU5CED3MyX';
    int decimals = 5;
    int amount = 100000;
    await WalletService.sendTransfer(accountPrivateKey, walletPassword, toAddress, symbol, tokenAddress, decimals, amount);
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
    uiAmount.value = int.parse(changeAmount);
  }
}
