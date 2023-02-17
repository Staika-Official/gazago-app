import 'package:solana/solana.dart';

class SolanaService {


  createWallet() async {
    Wallet wallet = await Ed25519HDKeyPair.random();
    print(wallet.address);
  }

}
