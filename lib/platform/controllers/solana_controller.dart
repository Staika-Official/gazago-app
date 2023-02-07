import 'dart:io';

import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/types/health_status.dart';
import 'package:gaza_go/flavors.dart';

class SolanaController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
  }

  void createWallet() async {
    final wallet = web3.Keypair.generate();
    final address = wallet.publicKey;
    print(address);
    print(address.toBase58());
    print(address.toBase64());
    print(wallet.secretKey);

    String encodeSecretKey = base58.encode(wallet.secretKey);
    print(encodeSecretKey);

    // 암호화 모듈 추가
    print(base58.decode(encodeSecretKey));
    await WalletService.createSolanaWallet(address.toBase58(), encodeSecretKey);

  }

  void sendTransfer(String toAddress) async {

  }
}
