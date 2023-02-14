import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/helpers/solana_helper.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/pay_response_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/flavors.dart';
import 'package:solana/base58.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

class WalletService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static String? get solanaSecretKey {
    return HiveStore.loadString(key: HiveKey.solanaSecretKey.name);
  }

  static Future<void> getSpendingWalletBalances({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletBalances();
    if (res.statusCode == 200) {
      List<AssetTokenBalanceModel> balanceList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => balanceList.add(AssetTokenBalanceModel.fromJson(item)));
      }
      successCallback(balanceList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getSpendingWalletBalance(String symbol, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletBalance(symbol);
    if (res.statusCode == 200) {
      successCallback(AssetTokenBalanceModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<AssetDetailModel> getSpendingWalletTransactions(String symbol, [int size = 10]) async {
    Response res = await WalletApi.getSpendingWalletTransactions(symbol, size);
    return AssetDetailModel.fromJson(res.data);
  }

  static Future<BuyTikResponseModel> buyTik(int tikAmount) async {
    Response res = await WalletApi.buyTik(tikAmount);
    return BuyTikResponseModel.fromJson(res.data);
  }

  //mint(토큰): TIK = 1 , STIK = 2
  static Future<PayResponseModel> payWithToken(PayInfoModel payInfo) async {
    Response res = await WalletApi.payWithToken(payInfo);
    return PayResponseModel.fromJson(res.data);
  }

  static Future<void> getFeeTik({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getFeeTik();
    if (res.statusCode == 200) {
      successCallback(res.data);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> createSolanaWallet(String publicKey, String encodeSecretKey) async {
    await WalletApi.postEncryptedSecretKey(publicKey, encodeSecretKey);
  }

  static Future<void> sendTransfer(String toAddress, String symbol, String tokenAddress, int decimals, int amount) async {
    final SolanaClient solanaClient = F.solanaClient;

    List<int> privateKey = [161, 38, 33, 160, 179, 255, 235, 121, 6, 215, 185, 63, 133, 112, 250, 78, 156, 177, 93, 135, 102, 5, 156, 160, 192, 128, 24, 162, 226, 8, 177, 116];

    String accountPrivateKey = 'Br4N3pMn2hjk2P685bN99FTYojhSuiRPUiz1YffX81HV';
    final sender = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58decode(accountPrivateKey),
    );
    final receiver = Ed25519HDPublicKey.fromBase58(toAddress);

    Message message;
    if (symbol == 'SOL') {
      message = getSolTransferMessage(sender.publicKey, receiver, amount);
    } else {
      final mint = Ed25519HDPublicKey.fromBase58(tokenAddress);
      message = await getSplTransferMessage(solanaClient, sender, receiver, mint, amount);
    }

    // FeePayer
    final feePayer = F.solanaFeePayer;

    final recentBlockhash = await solanaClient.rpcClient.getRecentBlockhash(commitment: Commitment.confirmed);
    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.blockhash,
      feePayer: feePayer,
    );

    final List<Signature> signatures = [];
    final feePayerSign = Signature(List.filled(64, 0), publicKey: sender.publicKey);
    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.data));

    SignedTx tx = SignedTx(
      messageBytes: compiledMessage.data,
      signatures: signatures,
    );

    // API Call
    Map<String, String> body = {
      'clientId': 'GAZAGO',
      'endocdeTransction': tx.encode()
    };
    Response res = await WalletApi.sendSolanaTransfer(body);



  }
}
