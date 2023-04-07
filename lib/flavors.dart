import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:solana/solana.dart';

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
        String? endPointType = HiveStore.load(key: HiveKey.endPointType.name);
        if (endPointType == null || endPointType == EndPointType.stage.name) {
          return BaseUrl.stage;
        } else {
          return BaseUrl.prod;
        }
      case Flavor.prod:
        String? endPointType = HiveStore.load(key: HiveKey.endPointType.name);
        if (endPointType == null || endPointType == EndPointType.prod.name) {
          return BaseUrl.prod;
        } else {
          return BaseUrl.stage;
        }
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

  static String get howToGoUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://eztechfin.notion.site/How-to-GO-61129dcb96324b0cb282d7743e19b043';
      case Flavor.stage:
        return 'https://eztechfin.notion.site/How-to-GO-61129dcb96324b0cb282d7743e19b043';
      case Flavor.prod:
        return 'https://eztechfin.notion.site/How-to-GO-61129dcb96324b0cb282d7743e19b043';
      default:
        return 'https://eztechfin.notion.site/How-to-GO-61129dcb96324b0cb282d7743e19b043';
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
          rpcUrl: Uri.parse('https://api.solana.com'),
          websocketUrl: Uri.parse('wss://api.solana.com'),
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
        return Ed25519HDPublicKey.fromBase58("E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
      case Flavor.stage:
        return Ed25519HDPublicKey.fromBase58("E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
      case Flavor.prod:
        return Ed25519HDPublicKey.fromBase58("jfMvdqtgQ4VnnhYgHEa1KEQSobiqy7dAFepr1CZRZ4A");
      default:
        return Ed25519HDPublicKey.fromBase58("E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
    }
  }

  static String get startAdIos {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/7717252030';
      default:
        return 'ca-app-pub-3940256099942544/1712485313';
    }
  }

  static String get startAdAndroid {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/8417209744';
      default:
        return 'ca-app-pub-3940256099942544/5224354917';
    }
  }

  static String get endAdIos {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/6348330049';
      default:
        return 'ca-app-pub-3940256099942544/1712485313';
    }
  }

  static String get endAdAndroid {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/9538719725';
      default:
        return 'ca-app-pub-3940256099942544/5224354917';
    }
  }
}
