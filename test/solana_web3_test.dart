


import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/programs/system.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/types/health_status.dart';
void main() {

  // 솔라나 토큰 트랜스퍼
  test('solana transfer sign', () async {
    WidgetsFlutterBinding.ensureInitialized();

    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    print('Creating accounts...\n');

    final wallet1 = await walletA();
    final address1 = wallet1.publicKey;

    final wallet2 = await walletB();
    final address2 = wallet2.publicKey;

    final bh = await connection.getLatestBlockhash();
    final transaction = web3.Transaction();
    transaction.add(
      SystemProgram.transfer(
        fromPublicKey: address1,
        toPublicKey: address2,
        lamports: web3.solToLamports(1),
      ),
    );

    print('Send and confirm transaction...\n');
    await connection.sendAndConfirmTransaction(
      transaction,
      signers: [wallet1], // Fee payer + transaction signer.
    );

    // Check the updated account balances.
    final wallet1balance = await connection.getBalance(wallet1.publicKey);
    final wallet2balance = await connection.getBalance(wallet2.publicKey);
    print('Account $address1 has an updated balance of $wallet1balance lamports.');
    print('Account $address2 has an updated balance of $wallet2balance lamports.');
  });

  // 솔라나 토큰 트랜스퍼 서명(이게 사용됨)
  test('solana transfer multisig', () async {
    WidgetsFlutterBinding.ensureInitialized();

    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    final wallet1 = await walletA();
    final address1 = wallet1.publicKey;

    final wallet2 = await walletB();
    final address2 = wallet2.publicKey;


    final feeWallet = await feePayerWallet();

    print(address1);
    print(address2);
    print(feeWallet.publicKey);

    PublicKey feePayer = PublicKey.fromBase58("92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc");
    final bh = await connection.getLatestBlockhash();
    final transaction = web3.Transaction(
      feePayer: feePayer,
      recentBlockhash: bh.blockhash,
    );
    transaction.add(
      SystemProgram.transfer(
        fromPublicKey: address1,
        toPublicKey: address2,
        lamports: BigInt.from(1000000),
      ),
    );

    transaction.partialSign([wallet1]);

    final txSerialize = transaction.serialize(SerializeConfig(requireAllSignatures: false, verifySignatures: false));

    print(txSerialize);

    print(base64.encode(txSerialize.asUint8List()));

    /*
    final wireTransaction = transaction.serialize();
    final encodedTransaction = base64.encode(wireTransaction.asUint8List());

    final signature = await connection.sendSignedTransactionRaw(
      encodedTransaction,
    );
     */




    /*
    await connection.sendAndConfirmTransaction(
      transaction,
      signers: [feeWallet, wallet1], // Fee payer + transaction signer.
    );
     */

    //print(signature);


    /*print(transaction.toJson());

    final txSerialize = transaction.serialize(SerializeConfig(requireAllSignatures: false, verifySignatures: false));

    print(txSerialize);

    print(base64.encode(txSerialize.asUint8List()));


    final transactionFromJson = Transaction.fromList(txSerialize.asUint8List());
    //transactionFromJson.partialSign([feeWallet]);

    final wireTransaction = transactionFromJson.serialize();
    final signature = await connection.sendTransactionRaw(
      Transaction.fromList(wireTransaction.asUint8List()),
    );*/

    //print('signature ${signature}');
  });

  // 솔라나 토큰 트랜스퍼 서명(이게 사용됨)
  test('airdrop', () async {

    WidgetsFlutterBinding.ensureInitialized();

    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    print(connection);

    final HealthStatus status = await connection.health();
    print('health ${status}');

    final wallet1 = await walletA();
    final address = wallet1.publicKey;

    print(address);

    final lamports = web3.lamportsPerSol * 2;
    final transactionSignature = await connection.requestAirdrop(address, lamports);
    await connection.confirmTransaction(transactionSignature);
  });
}

/// WARNING: Airdrops cannot be performed on the mainnet.
Future<web3.Keypair> createWalletWithBalance(
    final web3.Connection connection, {
      required final int amount,
    }) async {

  // Create a new wallet and get its public address.
  final wallet = web3.Keypair.generate();
  final address = wallet.publicKey;

  print(address);
  print(wallet.secretKey);

  // Airdrop some test tokens to the wallet address.
  // NOTE: Airdrops cannot be performed on the mainnet.
  if (amount > 0) {
    final lamports = web3.lamportsPerSol * amount;
    final transactionSignature = await connection.requestAirdrop(address, lamports);
    await connection.confirmTransaction(transactionSignature);
  }

  return wallet;
}

Future<web3.Keypair> walletA() async {
  return web3.Keypair.fromSecretKey(Uint8List.fromList([179, 242, 163, 65, 9, 177, 33, 213, 188, 118, 12, 231, 3, 166, 249, 254, 10, 68, 106, 95, 1, 254, 98, 23, 215, 26, 140, 181, 119, 243, 151, 219, 41, 104, 206, 115, 76, 224, 233, 41, 166, 176, 188, 93, 149, 84, 0, 235, 16, 162, 11, 40, 90, 238, 41, 90, 52, 197, 243, 54, 43, 200, 25, 220]));
}

Future<web3.Keypair> walletB() async {
  return web3.Keypair.fromSecretKey(Uint8List.fromList([7, 151, 239, 194, 176, 185, 103, 219,  69,  14,  65,
    230, 253,   2,   8, 178,   2, 129, 194, 144,  96, 235,
    152,  20,   2,  48,  64,  24,  45, 218, 171,  93, 120,
    4,  67, 229, 177,  33,  21, 179, 128, 164, 131, 189,
    68, 211, 195, 143, 167,  37,  94, 165,  96,  35,  95,
    125, 202,  96, 116, 151, 126, 123, 147,  97]));
}

Future<web3.Keypair> feePayerWallet() async {
  return web3.Keypair.fromSecretKey(Uint8List.fromList([ 62, 109, 167, 119, 110,  18, 127,  29, 154,  52, 119,
    35, 109,  87, 224,  81, 120,  62, 145, 178,  10, 157,
    133,  51,  92, 126, 185, 206, 158,   6, 141,  46, 119,
    58, 142,  99,  48, 129, 216, 104,  75, 100, 199, 189,
    44,  80,  64,  98, 249, 114, 163, 124, 179, 123, 129,
    168, 100,  48,  42,  49, 236, 174,  36, 153]));
}