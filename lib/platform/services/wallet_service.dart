import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/wallet.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:gaza_go/platform/helpers/solana_helper.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/exchange_token_withdrawal_model.dart';
import 'package:gaza_go/platform/models/nft_detail_model.dart';
import 'package:gaza_go/platform/models/nft_model.dart';
import 'package:gaza_go/platform/models/on_chain_wallet_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/pay_response_model.dart';
import 'package:gaza_go/platform/models/setting_environment_model.dart';
import 'package:gaza_go/platform/models/token_priority_fee_model.dart';
import 'package:gaza_go/platform/models/transfer_nft_request_model.dart';
import 'package:gaza_go/platform/models/wallet_solana_model.dart';
import 'package:gaza_go/platform/models/wallet_solana_transfer_model.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:solana/dto.dart';
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

  static Future<void> getSpendingWalletBalances({bool showLoading = false, required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletBalances(showLoading: showLoading);
    if (res.statusCode == 200) {
      List<AssetTokenBalanceModel> balanceList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => balanceList.add(AssetTokenBalanceModel.fromJson(item)));
      }
      successCallback(balanceList);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> getSpendingWalletBalance(String symbol, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletBalance(symbol);
    if (res.statusCode == 200) {
      successCallback(AssetTokenBalanceModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> getSpendingWalletTransactions(String symbol, {int page = 1, int size = 10, required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getSpendingWalletTransactions(symbol, page, size);
    if (res.statusCode == 200) {
      successCallback(AssetDetailModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
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

  static Future<void> getWalletAddress(String type, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getWalletAddress(type);
    if (res.statusCode == 200) {
      List<SettingEnvironmentModel> addressList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => addressList.add(SettingEnvironmentModel.fromJson(item)));
      }
      return successCallback(addressList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getProviderUrl({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getProviderUrl();
    if (res.statusCode == 200) {
      return successCallback(res.data);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<WalletSolanaModel?> getSolanaWallet() async {
    String? userId = HiveStore.loadString(key: HiveKey.userId.name);
    Response res = await WalletApi.getSolanaWallet(userId);

    if (res.data == null || res.data == '') {
      return null;
    }
    return WalletSolanaModel.fromJson(res.data);
  }

  static Future<WalletSolanaModel> createSolanaWallet(String walletPassword) async {
    // Solana Dart가 SecretKey 를 프라이빗으로 해둬서 값을 가져올수 없음. solana_web3 라이브러리 필요함
    final wallet = Keypair.generateSync();
    final address = wallet.pubkey;

    String? email = HiveStore.loadString(key: HiveKey.email.name);

    print('address: ${address.toBase58()}');
    print('secretKey: ${base58.encode(wallet.seckey)}');

    // 암호화된 시크릿키
    String encryptSecretKey = encrypt(base58.encode(wallet.seckey), email!, walletPassword);
    Response res = await WalletApi.createSolanaWallet(address.toBase58(), encryptSecretKey);

    return WalletSolanaModel.fromJson(res.data);
  }

  static Future<WalletSolanaTransferModel> transferSolana(String accountSecretkey, String walletPassword, String toAddress, String symbol, String tokenAddress, int decimals, int amount) async {
    late final SolanaClient solanaClient;
    int priorityFee = 0;
    String platform = 'solana';
    String symbol = 'STIK';

    await getProviderUrl(successCallback: (url) {
      solanaClient = SolanaClient(
        rpcUrl: Uri.parse(url),
        websocketUrl: Uri.parse(url.replaceAll('https', 'wss')),
      );
    }, errorCallback: (ErrorResponseDataModel e) {
      showToastPopup(e.errorMessage!);
      return;
    });

    await WalletService.getTokenPriorityFee(platform, symbol, successCallback: (fees) {
      print('fees: $fees');
      priorityFee = fees.priorityFee;
    }, errorCallback: () {
      showToastPopup('Failed to get fee');
      return;
    });
    String? email = HiveStore.loadString(key: HiveKey.email.name);

    print('##############');
    print('accountSecretkey: $accountSecretkey');
    String? decryptPrivateKey = decrypt(accountSecretkey, email!, walletPassword);
    print('decryptPrivateKey: $decryptPrivateKey');

    if (decryptPrivateKey == null) {}

    final sender = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58.decode(decryptPrivateKey!).sublist(0, 32),
    );
    final receiver = Ed25519HDPublicKey.fromBase58(toAddress);

    solana.Message message;
    if (symbol == 'SOL') {
      message = getSolTransferMessage(sender.publicKey, receiver, amount, priorityFee);
    } else {
      final mint = Ed25519HDPublicKey.fromBase58(tokenAddress);
      message = await getSplTransferMessage(solanaClient, sender, receiver, mint, amount, priorityFee);
    }

    print('sender: ${sender.address}');

    // FeePayer
    late final Ed25519HDPublicKey feePayer;
    await WalletService.getWalletAddress(
      'SOLANA_FEE_WALLET',
      successCallback: (address) {
        feePayer = Ed25519HDPublicKey.fromBase58(address[0].value);
      },
    );

    final recentBlockhash = await solanaClient.rpcClient.getLatestBlockhash(commitment: solana.Commitment.confirmed);
    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.value.blockhash,
      feePayer: feePayer,
    );

    final List<Signature> signatures = [];
    final feePayerSign = Signature(List.filled(64, 0), publicKey: feePayer);
    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.toByteArray()));

    SignedTx tx = SignedTx(
      compiledMessage: compiledMessage,
      signatures: signatures,
    );

    // API Call
    Map<String, String> body = {'clientId': 'GAZAGO', 'encodeTransaction': tx.encode()};
    Response res = await WalletApi.transferSolana(body);
    return WalletSolanaTransferModel.fromJson(res.data);
  }

  //onchain apis
  static Future<void> getOnChainWallet({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getOnChainWallet(userId!);
    if (res.statusCode == 200) {
      successCallback(OnChainWalletModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> createOnChainWallet({required String walletPassword, required Function successCallback, Function? errorCallback}) async {
    final wallet = Keypair.generateSync();
    String? email = HiveStore.loadString(key: HiveKey.email.name);

    String publicKey = wallet.pubkey.toBase58();
    // 암호화된 시크릿키
    String encryptSecretKey = encrypt(base58.encode(wallet.seckey), email!, walletPassword);

    Response res = await WalletApi.createOnChainWallet(userId!, publicKey: publicKey, secretKey: encryptSecretKey);
    if (res.statusCode == 201) {
      successCallback(OnChainWalletModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<bool> encryptionIsValid({required String walletPassword}) async {
    Response res = await WalletApi.getOnChainWallet(userId!);
    if (res.statusCode == 200) {
      OnChainWalletModel walletPair = OnChainWalletModel.fromJson(res.data);

      String? email = HiveStore.loadString(key: HiveKey.email.name);
      String? decrypted = decrypt(walletPair.secretKey, email!, walletPassword);

      if (decrypted != null) {
        try {
          const Utf8Decoder(allowMalformed: false).convert(decrypted.codeUnits);
          return true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<void> disableOnChainWallet({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.disableOnChainWallet(userId!);
    if (res.statusCode == 200) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> getOnChainTokenBalance({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getOnChainTokenBalance(userId!);
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

  static Future<void> getOnChainBalanceByToken(String symbol, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getOnChainBalanceByToken(userId!, symbol);
    if (res.statusCode == 200) {
      successCallback(WalletTokenBalanceModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> fetchStikMoveToGoWallet({
    required Function successCallback,
    Function? errorCallback,
    required String accountSecretkey,
    required String walletPassword,
    required Ed25519HDPublicKey toAddress,
    required String symbol,
    required Ed25519HDPublicKey tokenAddress,
    required int decimals,
    required int amount,
  }) async {
    late final SolanaClient solanaClient;
    int priorityFee = 0;
    String platform = 'solana';
    String symbol = 'STIK';

    await getProviderUrl(successCallback: (url) {
      solanaClient = SolanaClient(
        rpcUrl: Uri.parse(url),
        websocketUrl: Uri.parse(url.replaceAll('https', 'wss')),
      );
    }, errorCallback: (ErrorResponseDataModel e) {
      showToastPopup(e.errorMessage!);
      return;
    });

    await WalletService.getTokenPriorityFee(platform, symbol, successCallback: (fees) {
      print('fees: $fees');
      priorityFee = fees.priorityFee;
      print('fees: ${fees.priorityFee}');
    }, errorCallback: () {
      showToastPopup('Failed to get fee');
      return;
    });
    String? email = HiveStore.loadString(key: HiveKey.email.name);
    // print(email);
    // print('##############');
    // print('accountSecretkey: $accountSecretkey');
    // print(walletPassword);
    String? decryptPrivateKey = decrypt(accountSecretkey, email!, walletPassword);
    // print(decryptPrivateKey);

    // if (decryptPrivateKey == null) {
    //   if (errorCallback != null) errorCallback(true);
    //   return;
    // }
    // print(email);
    // print(decryptPrivateKey);
    final sender = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58.decode(decryptPrivateKey!).sublist(0, 32),
    );
    // print(sender);
    final receiver = toAddress;

    solana.Message message;
    try {
      if (symbol == 'SOL') {
        message = getSolTransferMessage(sender.publicKey, receiver, amount, priorityFee);
      } else {
        final mint = tokenAddress;
        message = await getSplTransferMessage(solanaClient, sender, receiver, mint, amount, priorityFee);
      }
    } catch (e) {
      showToastPopup('메세지 안돼');
      if (errorCallback != null) errorCallback(true);
      return;
    }

    // FeePayer
    late final Ed25519HDPublicKey feePayer;
    await WalletService.getWalletAddress(
      'SOLANA_FEE_WALLET',
      successCallback: (address) {
        feePayer = Ed25519HDPublicKey.fromBase58(address[0].value);
      },
    );

    final recentBlockhash = await solanaClient.rpcClient.getLatestBlockhash(commitment: solana.Commitment.confirmed);
    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.value.blockhash,
      feePayer: feePayer,
    );

    final List<Signature> signatures = [];
    final feePayerSign = Signature(List.filled(64, 0), publicKey: feePayer);
    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.toByteArray()));

    SignedTx tx = SignedTx(
      compiledMessage: compiledMessage,
      signatures: signatures,
    );
    String uiAmount = getUiAmountString(amount, decimals);
    print(uiAmount);
    // API Call
    // Map<String, String> body = {'clientId': 'GAZAGO', 'encodeTransaction': tx.encode()};
    ExchangeTokenWithdrawalModel params = ExchangeTokenWithdrawalModel(
      type: 'withdrawal',
      uiAmount: double.parse(uiAmount),
      fee: 0,
      encodedTransaction: tx.encode(),
    );
    Response res = await WalletApi.exchangeStikToGoWallet(userId!, symbol, params);
    if (res.statusCode == 201) {
      successCallback(true);
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> fetchStikMoveToStaikaWallet({
    required Function successCallback,
    Function? errorCallback,
    required String symbol,
    required double amount,
  }) async {
    ExchangeTokenWithdrawalModel params = ExchangeTokenWithdrawalModel(
      type: 'deposit',
      uiAmount: amount,
      fee: 0,
      encodedTransaction: '',
    );
    Response res = await WalletApi.exchangeStikToGoWallet(userId!, symbol, params);
    if (res.statusCode == 201) {
      successCallback(true);
    } else {
      // if (errorCallback != null) errorCallback();
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> getTokenPriorityFee(String platform, String symbol, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getTokenPriorityFee(platform, symbol);
    if (res.statusCode == 200) {
      successCallback(TokenPriorityFeeModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> getNftList({required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getNftList(userId!);
    if (res.statusCode == 200) {
      List<NftModel> nftListList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => nftListList.add(NftModel.fromJson(item)));
      }
      successCallback(nftListList);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> getNftDetail(String mintAddress, {required Function successCallback, Function? errorCallback}) async {
    Response res = await WalletApi.getNftDetail(mintAddress);
    if (res.statusCode == 200) {
      successCallback(NftDetailModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> transferNftToGoWallet({
    required Function successCallback,
    Function? errorCallback,
    required String accountSecretkey,
    required String walletPassword,
    required Ed25519HDPublicKey toAddress,
    required String mintAddress,
  }) async {
    late final SolanaClient solanaClient;
    late final solana.Message message;
    late final LatestBlockhashResult recentBlockhash;
    late final SignedTx tx;
    int priorityFee = 0;
    String platform = 'solana';
    String symbol = 'STIK';

    await getProviderUrl(successCallback: (url) {
      solanaClient = SolanaClient(
        rpcUrl: Uri.parse(url),
        websocketUrl: Uri.parse(url.replaceAll('https', 'wss')),
      );
    }, errorCallback: (ErrorResponseDataModel e) {
      showToastPopup(e.errorMessage!);
      return;
    });

    await WalletService.getTokenPriorityFee(platform, symbol, successCallback: (fees) {
      priorityFee = fees.priorityFee;
    }, errorCallback: () {
      showToastPopup('Failed to get fee');
      return;
    });

    String? email = HiveStore.loadString(key: HiveKey.email.name);
    String? decryptPrivateKey = decrypt(accountSecretkey, email!, walletPassword);
    final sender = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58.decode(decryptPrivateKey!).sublist(0, 32),
    );

    final mint = solana.Ed25519HDPublicKey.fromBase58(mintAddress);

    try {
      message = await getNftTransferMessage(solanaClient, sender, toAddress, mint, priorityFee);
    } catch (e) {
      showBlockchainNetworkErrorAlert();
      return;
    }

    recentBlockhash = await solanaClient.rpcClient.getLatestBlockhash(commitment: solana.Commitment.confirmed);
    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.value.blockhash,
      feePayer: toAddress,
    );

    final List<solana.Signature> signatures = [];
    final feePayerSign = Signature(List.filled(64, 0), publicKey: toAddress);
    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.toByteArray()));

    tx = SignedTx(
      compiledMessage: compiledMessage,
      signatures: signatures,
    );

    TransferNftRequestModel data = TransferNftRequestModel(tokenAddress: mintAddress, encodedTransaction: tx.encode());

    Response res = await WalletApi.transferNftToGoWallet(userId!, data);
    if (res.statusCode == 201) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }
}
