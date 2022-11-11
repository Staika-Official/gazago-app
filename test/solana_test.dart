

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

void main() {

  final rpcUrl = 'https://api.devnet.solana.com';

  final subscriptionClient = SubscriptionClient.connect('wss://api.devnet.solana.com');

  test('create wallet', () async {
    final randomKeyPair = await Ed25519HDKeyPair.random();
    print('address ${randomKeyPair.address}');
    final privateKey = await randomKeyPair.extract();
    print('private key ${privateKey.toString()}');
    print('private key bytes ${privateKey.bytes}');
  });

  test('import wallet', () async {
    final address = '6BufeZ6DFnpjn4KLG5gfe3DLAVAoS3imQxYBP6DzbMBg';
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

  test('solana token transfer', () async {
    final SolanaClient solanaClient = SolanaClient(
        rpcUrl: Uri.parse('https://api.devnet.solana.com'),
        websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );

    final sender = await getWalletA();
    final receiver = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');

    final signature = await solanaClient.transferLamports(
      destination: receiver,
      lamports: 100000000,
      source: sender,
      commitment: Commitment.confirmed,
    );

    print('signature ${signature}');
  });

  // 솔라나 토큰 트랜스퍼 서명(이게 사용됨)
  test('solana token transfer sign', () async {
    final rpcClient = RpcClient(rpcUrl);

    final sender = await getWalletA();
    final receiver = Ed25519HDPublicKey.fromBase58('4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1');

    final instructions = [
      SystemInstruction.transfer(
        fundingAccount: sender.publicKey,
        recipientAccount: receiver,
        lamports: 200000000,
      ),
    ];

    print(instructions);

    final tx = await signTransaction(
      await rpcClient.getRecentBlockhash(commitment: Commitment.finalized),
      Message(instructions: instructions),
      [sender], // 보내는 사람 서명 필요
    );

    print('tx ${tx.encode()}');
  });


  test('Initialize Mint', () async {
    final rpcClient = RpcClient(rpcUrl);

    final rent = await rpcClient
        .getMinimumBalanceForRentExemption(TokenProgram.neededMintAccountSpace);

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

    print('signature ${signature}');
  });

  test('Create Token Account', () async {
    final rpcClient = RpcClient(rpcUrl);

    final rent = await rpcClient
        .getMinimumBalanceForRentExemption(TokenProgram.neededAccountSpace);

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

    print('signature ${signature}');
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

    print('signature ${signature}');
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

    print('instruction ${instruction.data}');

    final signature = await rpcClient.signAndSendTransaction(
      Message.only(instruction),
      [owner],
      commitment: Commitment.confirmed,
    );

    print('signature $signature');

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



Future<Ed25519HDKeyPair> getWalletA() async {
  final address = '6BufeZ6DFnpjn4KLG5gfe3DLAVAoS3imQxYBP6DzbMBg';
  List<int> privateKey = [161, 38, 33, 160, 179, 255, 235, 121, 6, 215, 185, 63, 133, 112, 250, 78, 156, 177, 93, 135, 102, 5, 156, 160, 192, 128, 24, 162, 226, 8, 177, 116];
  final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
    privateKey: privateKey,
  );
  return wallet;
}

Ed25519HDPublicKey getWalletATokenAccount() {
  return Ed25519HDPublicKey.fromBase58('2kZ42k3Nmnxmfbsk4vxTciBPrK3nA39VhLYJYSSXpRew');
}

Future<Ed25519HDKeyPair> getWalletB() async {
  String address = '4L3ScUzhGu9onoZ6bbXCeFKFhkJ6tMAUHunj9akLu2P1';
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