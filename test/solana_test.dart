import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

void main() {
  const rpcUrl = 'https://api.devnet.solana.com';

  final subscriptionClient = SubscriptionClient.connect('wss://api.devnet.solana.com');

  test('create wallet', () async {
    final randomKeyPair = await Ed25519HDKeyPair.random();
    print('address ${randomKeyPair.address}');
    final privateKey = await randomKeyPair.extract();
    print('private key ${privateKey.toString()}');
    print('private key bytes ${privateKey.bytes}');
  });

  test('import wallet', () async {
    // final address = '6BufeZ6DFnpjn4KLG5gfe3DLAVAoS3imQxYBP6DzbMBg';
    List<int> privateKey = [161, 38, 33, 160, 179, 255, 235, 121, 6, 215, 185, 63, 133, 112, 250, 78, 156, 177, 93, 135, 102, 5, 156, 160, 192, 128, 24, 162, 226, 8, 177, 116];
    final testKeyPair = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: privateKey,
    );

    print('address ${testKeyPair.address}');
  });

  test('airdrop', () async {
    final wallet = await getWalletA();

    final rpcClient = RpcClient(rpcUrl);
    final signature = await rpcClient.requestAirdrop(
      wallet.address,
      2 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );

    print('signature $signature');

    await subscriptionClient.waitForSignatureStatus(
      signature,
      status: Commitment.confirmed,
    );
  });

  test('sol transfer', () async {
    final SolanaClient solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.devnet.solana.com'),
      websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );

    final sender = await getWalletA();
    final receiver = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');

    final instruction = SystemInstruction.transfer(
      fundingAccount: sender.publicKey,
      recipientAccount: receiver,
      lamports: 10000000,
    );

    final signature = await solanaClient.sendAndConfirmTransaction(
      message: Message.only(instruction),
      signers: [sender],
      commitment: Commitment.confirmed,
    );

    print('signature $signature');
  });

  test('spl transfer', () async {
    final SolanaClient solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.devnet.solana.com'),
      websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );

    const commitment = Commitment.confirmed;

    final sender = await getWalletA();
    final destination = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');
    final mint = Ed25519HDPublicKey.fromBase58('9TuCLrnSUt2iX6tccPEHSLgUMDg3VpkoEazU5CED3MyX');

    ProgramAccount? associatedRecipientAccount = await solanaClient.getAssociatedTokenAccount(
      owner: destination,
      mint: mint,
      commitment: commitment,
    );
    ProgramAccount? associatedSenderAccount = await solanaClient.getAssociatedTokenAccount(
      owner: sender.publicKey,
      mint: mint,
      commitment: commitment,
    );

    // Throw an appropriate exception if the sender has no associated
    // token account
    if (associatedSenderAccount == null) {
      throw NoAssociatedTokenAccountException(sender.address, mint.toBase58());
    }
    // Also throw an adequate exception if the recipient has no associated
    // token account
    if (associatedRecipientAccount == null) {
      associatedRecipientAccount = await solanaClient.createAssociatedTokenAccount(
        mint: mint,
        funder: sender,
        owner: destination,
        commitment: Commitment.confirmed,
      );

      print(associatedRecipientAccount.pubkey);
    }

    print('associatedSenderAccount: ${associatedSenderAccount.pubkey}');
    print('associatedRecipientAccount: ${associatedRecipientAccount.pubkey}');

    int amount = 10000;

    final instruction = TokenInstruction.transfer(
      source: Ed25519HDPublicKey.fromBase58(associatedSenderAccount.pubkey),
      destination: Ed25519HDPublicKey.fromBase58(associatedRecipientAccount.pubkey),
      owner: sender.publicKey,
      amount: amount,
    );

    final message = Message(
      instructions: [
        instruction
        /*,
        if (memo != null && memo.isNotEmpty)
          MemoInstruction(signers: [owner.publicKey], memo: memo),*/
      ],
    );

    final signature = await solanaClient.sendAndConfirmTransaction(
      message: message,
      signers: [sender],
      commitment: commitment,
    );

    print(signature);
  });

  // 솔라나 전송 연계
  test('sol11 transfer interface', () async {
    final rpcClient = RpcClient(rpcUrl);

    final sender = await getWalletA();

    final receiver = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');

    final instruction = SystemInstruction.transfer(
      fundingAccount: sender.publicKey,
      recipientAccount: receiver,
      lamports: 10000000,
    );

    final tx = await signTransaction(
      await rpcClient.getRecentBlockhash(commitment: Commitment.confirmed).value,
      Message.only(instruction),
      [sender],
    );

    //await onSigned(tx.signatures.first.toBase58());

    print(sender.publicKey.toBase58());
    print('resignedTx ${tx.encode()}');

    const accessToken =
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfVVNFUiIsImV4cCI6MTY3NjI2OTM3MSwidXNlcklkIjoiMyJ9.s9lJOVIOOuIBKAdRKxcyNnZoEvWVNga_dLISIMgAWDn5MvF8pdmAddqskGPHOVBlGg-nLq1IVudbcKJ_SWqxog';

    final send = {'clientId': 'GAZAGO', 'endocdeTransction': tx.encode()};

    try {
      var response = await Dio().post('http://localhost:8080/services/gazago-wallet/api/solana/wallet/test/transfer',
          data: send,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ));
      print(response.data);
    } catch (e) {
      print(e);
    }

    /*SignedTx signature = await signTransactionCustom(recentBlockhash, Message.only(instructions[0]), [sender], Ed25519HDPublicKey.fromBase58('47NHwdLy1u3er4kH9PycRNzowGN3oJtMoHRbJRhFX3MV'));

    print(signature.signatures.length);

    */ /* final signature = await rpcClient.signMessage(
      Message.only(instruction),
      [owner],
      commitment: Commitment.confirmed,
    );*/ /*
    print('signature ${signature.encode()}');*/
  });

  // 솔라나 토큰 트랜스퍼 서명(이게 사용됨)
  test('solana-token transfer sign', () async {
    final rpcClient = RpcClient(rpcUrl);

    final sender = await getWalletA();
    final receiver = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');

    final instruction = SystemInstruction.transfer(
      fundingAccount: sender.publicKey,
      recipientAccount: receiver,
      lamports: 10000000,
    );

    print(sender.publicKey.toBase58());

    final recentBlockhash = await rpcClient.getLatestBlockhash(commitment: Commitment.confirmed);

    Message message = Message.only(instruction);

    final feePayer = Ed25519HDPublicKey.fromBase58('92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc');

    final CompiledMessage compiledMessage = message.compile(
      recentBlockhash: recentBlockhash.value.blockhash,
      feePayer: feePayer,
    );

    final List<Signature> signatures = [];

    final feePayerSign = Signature(List.filled(64, 0), publicKey: sender.publicKey);

    signatures.add(feePayerSign);
    signatures.add(await sender.sign(compiledMessage.toByteArray()));

    SignedTx reSignedTx = SignedTx(
      compiledMessage: compiledMessage,
      signatures: signatures,
    );

    const accessToken =
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfVVNFUiIsImV4cCI6MTY3NjI3Njk1MiwidXNlcklkIjoiMyJ9.MDgxZSVg1rNKBLs_GrjBZFSp3bwKAiExvvO4R1ct5YyZFI9rWxYqRE2sD9071xUHWgYWlCeRGTR7cG9VCSKcFQ';

    /*
    SignedTx tx = SignedTx(
      messageBytes: compiledMessage.data,
      signatures: signatures,
    );

    print('resignedTx ${tx.encode()}');



    final reTransaction = await getFeeSign(accessToken, tx.encode());


    SignedTx reSignedTx = SignedTx.decode(reTransaction);
    print(reSignedTx);

    reSignedTx.signatures.toList(growable: true).add(await sender.sign(compiledMessage.data));
*/
    final send = {'clientId': 'GAZAGO', 'endocdeTransction': reSignedTx.encode()};

    try {
      var response = await Dio().post('http://localhost:8080/services/gazago-wallet/api/solana/wallet/test/transfer',
          data: send,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ));
      print(response.data);
    } catch (e) {
      print(e);
    }
  });

  test('Initialize Mint', () async {
    final rpcClient = RpcClient(rpcUrl);

    final rent = await rpcClient.getMinimumBalanceForRentExemption(TokenProgram.neededMintAccountSpace);

    final mint = await Ed25519HDKeyPair.random();

    final mintAuthority = await getWalletA();

    // Not throwing is sufficient as test, we need the mint to exist
    final instructions = TokenInstruction.createAccountAndInitializeMint(
      mint: mint.publicKey,
      mintAuthority: mintAuthority.publicKey,
      freezeAuthority: mintAuthority.publicKey,
      rent: rent,
      space: TokenProgram.neededMintAccountSpace,
      decimals: 5,
    );

    final signature = await rpcClient.signAndSendTransaction(
      Message(instructions: instructions),
      [mintAuthority, mint],
      commitment: Commitment.confirmed,
    );

    print('signature $signature');
  });

  test('Create Token Account', () async {
    final rpcClient = RpcClient(rpcUrl);

    final rent = await rpcClient.getMinimumBalanceForRentExemption(TokenProgram.neededAccountSpace);

    print('rent $rent');

    //final owner = await getWalletA();
    final owner = await getWalletB();

    final tokensHolder = await Ed25519HDKeyPair.random();

    final instructions = TokenInstruction.createAndInitializeAccount(
      mint: getTokenAddress(),
      address: tokensHolder.publicKey,
      owner: owner.publicKey,
      rent: rent,
      space: TokenProgram.neededAccountSpace,
    );

    final signature = await rpcClient.signAndSendTransaction(
      Message(instructions: instructions),
      [owner, tokensHolder],
      commitment: Commitment.confirmed,
    );

    print('signature $signature');
  });

  test('Mint To', () async {
    final rpcClient = RpcClient(rpcUrl);

    final owner = await getWalletA();

    final tokenAccount = getWalletATokenAccount();

    final instruction = TokenInstruction.mintTo(
      mint: getTokenAddress(),
      destination: tokenAccount,
      authority: owner.publicKey,
      amount: 10000000000,
    );

    final signature = await rpcClient.signAndSendTransaction(
      Message.only(instruction),
      [owner],
      commitment: Commitment.confirmed,
    );

    print('signature $signature');
  });

  test('token transfer', () async {
    final rpcClient = RpcClient(rpcUrl);

    final tokenAccount = getWalletATokenAccount();
    final owner = await getWalletA();
    final receiver = getWalletBTokenAccount();

    final instruction = TokenInstruction.transfer(
      source: tokenAccount,
      destination: receiver,
      owner: owner.publicKey,
      amount: 10000000,
    );
    print('instruction $instruction');

    final recentBlockhash = await rpcClient.getLatestBlockhash(commitment: Commitment.confirmed);

    SignedTx signature = await signTransactionCustom(recentBlockhash, Message.only(instruction), [owner], Ed25519HDPublicKey.fromBase58('47NHwdLy1u3er4kH9PycRNzowGN3oJtMoHRbJRhFX3MV'));

    /* final signature = await rpcClient.signMessage(
      Message.only(instruction),
      [owner],
      commitment: Commitment.confirmed,
    );*/
    print('signature ${signature.encode()}');

    // final token = '';

    final send = {'clientId': 'GAZAGO', 'transInfo': signature.encode()};

    print('3333333333333333333333333');

    try {
      var response = await Dio().post('http://localhost:8089/api/solana/wallet/test/transfer', data: send);
      print(response);
    } catch (e) {
      print(e);
    }

    /*refreshDio.post('http://localhost:8089/api/solana/wallet/test/transfer', data: send).then((Response res) {
        print('data ${res.data}');
      }).catchError((e) {
        print('catchError ${e.toString()}');
      });*/

    /*final SolanaClient solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.devnet.solana.com'),
      websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );

    final token = getTokenAddress();
    final sender = await getWalletA();
    final receiver = await getWalletB();

    await solanaClient.transferSplToken(
      owner: sender,
      destination: receiver.publicKey,
      amount: 100,
      mint: token,
      commitment: Commitment.confirmed,
    );
    */
  });
}

Future<String> getFeeSign(accessToken, tx) async {
  final send = {'clientId': 'GAZAGO', 'endocdeTransction': tx};

  var response = await Dio().post('http://localhost:8080/services/gazago-wallet/api/solana/wallet/test/sign',
      data: send,
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ));
  print(response.data);
  return response.data['signature'];
}

Future<Ed25519HDKeyPair> getWalletA() async {
  // final address = '6BufeZ6DFnpjn4KLG5gfe3DLAVAoS3imQxYBP6DzbMBg';
  List<int> privateKey = [161, 38, 33, 160, 179, 255, 235, 121, 6, 215, 185, 63, 133, 112, 250, 78, 156, 177, 93, 135, 102, 5, 156, 160, 192, 128, 24, 162, 226, 8, 177, 116];

  String endcode = base58encode(privateKey);
  print('endcode $endcode');

  final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
    privateKey: privateKey,
  );
  return wallet;
}

Ed25519HDPublicKey getWalletATokenAccount() {
  return Ed25519HDPublicKey.fromBase58('2kZ42k3Nmnxmfbsk4vxTciBPrK3nA39VhLYJYSSXpRew');
}

Future<Ed25519HDKeyPair> getWalletB() async {
  // String address = '4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1';
  List<int> privateKey = [156, 174, 186, 87, 109, 39, 222, 252, 251, 84, 238, 187, 115, 49, 26, 79, 220, 78, 134, 99, 30, 196, 72, 51, 199, 107, 175, 192, 252, 93, 9, 21];
  final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
    privateKey: privateKey,
  );
  return wallet;
}

Ed25519HDPublicKey getWalletBTokenAccount() {
  return Ed25519HDPublicKey.fromBase58('9UZbKKQtfDjQwPaKWwasScjSiUqbYioGufyyh55KgwaK');
}

Ed25519HDPublicKey getTokenAddress() {
  return Ed25519HDPublicKey.fromBase58('DK7mBZtspjHP9LdPbZ3cT8tae2XNJvPgWsuEqqbE1tSL');
}

Future<SignedTx> signTransactionCustom(
  LatestBlockhashResult recentBlockhash,
  Message message,
  List<Ed25519HDKeyPair> signers,
  Ed25519HDPublicKey feePayer,
) async {
  if (signers.isEmpty) {
    throw const FormatException('you must specify at least on signer');
  }

  final CompiledMessage compiledMessage = message.compile(
    recentBlockhash: recentBlockhash.value.blockhash,
    feePayer: feePayer,
  );

  /*
  final int requiredSignaturesCount = compiledMessage.requiredSignatureCount;
  if (signers.length != requiredSignaturesCount) {
    throw FormatException(
      'your message requires $requiredSignaturesCount signatures but '
          'you provided ${signers.length}',
    );
  }
   */

  // FIXME(IA): signatures must match signers in the message accounts sorting
  final List<Signature> signatures = await Future.wait(
    signers.map((signer) => signer.sign(compiledMessage.toByteArray())),
  );

  return SignedTx(
    compiledMessage: compiledMessage,
    signatures: signatures,
  );
}
