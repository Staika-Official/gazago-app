import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:gaza_go/platform/helpers/solana_helper.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/on_chain_wallet_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/pay_response_model.dart';
import 'package:gaza_go/platform/models/wallet_solana_model.dart';
import 'package:gaza_go/platform/models/wallet_solana_transfer_model.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana_web3/solana_web3.dart';

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

  static Future<WalletSolanaModel?> getSolanaWallet() async {
    String? userId = HiveStore.loadString(key: HiveKey.userId.name);
    Response res = await WalletApi.getSolanaWallet(userId);
    print(res.data);
    if (res.data == null || res.data == '') {
      return null;
    }
    return WalletSolanaModel.fromJson(res.data);
  }

  static Future<WalletSolanaModel> createSolanaWallet(String walletPassword) async {
    // Solana Dart가 SecretKey 를 프라이빗으로 해둬서 값을 가져올수 없음. solana_web3 라이브러리 필요함
    final wallet = Keypair.generateSync();
    final address = wallet.publicKey;

    String? email = HiveStore.loadString(key: HiveKey.email.name);

    print('address: ${address.toBase58()}');
    print('secretKey: ${base58.encode(wallet.secretKey)}');

    // 암호화된 시크릿키
    String encryptSecretKey = encrypt(base58.encode(wallet.secretKey), email!, walletPassword);
    Response res = await WalletApi.createSolanaWallet(address.toBase58(), encryptSecretKey);

    return WalletSolanaModel.fromJson(res.data);
  }

  static Future<WalletSolanaTransferModel> transferSolana(String accountSecretkey, String walletPassword, String toAddress, String symbol, String tokenAddress, int decimals, int amount) async {
    final SolanaClient solanaClient = F.solanaClient;

    String? email = HiveStore.loadString(key: HiveKey.email.name);

    print('##############');
    print('accountSecretkey: ${accountSecretkey}');
    String? decryptPrivateKey = decrypt(accountSecretkey, email!, walletPassword);
    print('decryptPrivateKey: ${decryptPrivateKey}');

    if (decryptPrivateKey == null) {}

    final sender = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58.decode(decryptPrivateKey!).sublist(0, 32),
    );
    final receiver = Ed25519HDPublicKey.fromBase58(toAddress);

    solana.Message message;
    if (symbol == 'SOL') {
      message = getSolTransferMessage(sender.publicKey, receiver, amount);
    } else {
      final mint = Ed25519HDPublicKey.fromBase58(tokenAddress);
      message = await getSplTransferMessage(solanaClient, sender, receiver, mint, amount);
    }

    print('sender: ${sender.address}');

    // FeePayer
    final feePayer = F.solanaFeePayer;

    final recentBlockhash = await solanaClient.rpcClient.getRecentBlockhash(commitment: Commitment.confirmed);
    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.blockhash,
      feePayer: feePayer,
    );

    final List<Signature> signatures = [];
    final feePayerSign = Signature(List.filled(64, 0), publicKey: feePayer);
    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.data));

    SignedTx tx = SignedTx(
      messageBytes: compiledMessage.data,
      signatures: signatures,
    );

    // API Call
    Map<String, String> body = {'clientId': 'GAZAGO', 'encodeTransaction': tx.encode()};
    Response res = await WalletApi.transferSolana(body);
    return WalletSolanaTransferModel.fromJson(res.data);
  }

  //onchain apis
  static Future<void> getOnChainWallet({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getOnChainWallet(userId);
    if (res.statusCode == 200) {
      successCallback(OnChainWalletModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> createOnChainWallet({required String publicKey, required String secretKey, required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.createOnChainWallet(userId, publicKey: publicKey, secretKey: secretKey);
    if (res.statusCode == 201) {
      successCallback(OnChainWalletModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getOnChainTokenBalance({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getOnChainTokenBalance(userId);
    if (res.statusCode == 200) {
      List<WalletTokenBalanceModel> balanceList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => balanceList.add(WalletTokenBalanceModel.fromJson(item)));
      }
      successCallback(balanceList);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }
}
