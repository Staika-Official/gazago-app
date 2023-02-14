import 'package:gaza_go/constants/base_urls.dart';
import 'package:solana/solana.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/solana_web3.dart';

enum Flavor {
  dev,
  stage,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return '가자고-dev';
      case Flavor.stage:
        return '가자고-stage';
      case Flavor.prod:
        return '가자고';
      default:
        return 'title';
    }
  }

  static bool get isDev {
    return appFlavor != Flavor.prod;
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return BaseUrl.dev;
      case Flavor.stage:
        return BaseUrl.stage;
      case Flavor.prod:
        return BaseUrl.prod;
      default:
        return BaseUrl.dev;
    }
  }

  static String get taikaPayUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://stage.taikapay.com';
      case Flavor.stage:
        return 'https://stage.taikapay.com';
      case Flavor.prod:
        return 'https://taikapay.com';
      default:
        return 'https://stage.taikapay.com';
    }
  }

  static SolanaClient get solanaClient {
    switch (appFlavor) {
      case Flavor.dev:
        return SolanaClient(
          rpcUrl: Uri.parse('https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );
      case Flavor.stage:
        return SolanaClient(
          rpcUrl: Uri.parse('https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );
      case Flavor.prod:
        return SolanaClient(
          rpcUrl: Uri.parse('https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );
      default:
        return SolanaClient(
          rpcUrl: Uri.parse('https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );
    }
  }

  static Ed25519HDPublicKey get solanaFeePayer {
    switch (appFlavor) {
      case Flavor.dev:
        return Ed25519HDPublicKey.fromBase58("92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc");
      case Flavor.stage:
        return Ed25519HDPublicKey.fromBase58("92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc");
      case Flavor.prod:
        return Ed25519HDPublicKey.fromBase58("92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc");
      default:
        return Ed25519HDPublicKey.fromBase58("92RJbkjWhnqpKMepWGe6WXo94XeAQszX2PTStS7weZLc");
    }
  }
}
