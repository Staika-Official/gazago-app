import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/pay_response_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart';

import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:gaza_go/flavors.dart';

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
    await WalletApi.generateSolanaWallet(userId!, publicKey, encodeSecretKey);
  }

  static Future<void> sendTransfer(String toAddress, String symbol, int decimals, int amount) async {
    final cluster = F.solanaCluster;
    final connection = web3.Connection(cluster);
    int sendAmount = amount * pow(10, decimals).toInt();

    final fromAccount = web3.Keypair.fromSecretKey(base58.decode(solanaSecretKey!));
    PublicKey toPublicKey = PublicKey.fromBase58(toAddress);
    PublicKey feePayer = F.solanaFeePayer;

    final bh = await connection.getLatestBlockhash();

    // Transaction 생성
    final transaction = web3.Transaction(
      feePayer: feePayer,
      recentBlockhash: bh.blockhash,
    );

    transaction.add(
      SystemProgram.transfer(
        fromPublicKey: fromAccount.publicKey,
        toPublicKey: toPublicKey,
        //lamports: BigInt.from(1000000),
        lamports: BigInt.from(sendAmount),
      ),
    );

    transaction.partialSign([fromAccount]);
    final txSerialize = transaction.serialize(SerializeConfig(requireAllSignatures: false, verifySignatures: false));

    final send = {
      'clientId': 'GAZAGO',
      'endocdeTransction': base64.encode(txSerialize.asUint8List())
    };

    // API Call
  }
}
