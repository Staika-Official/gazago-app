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

  static String get leaderboardUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://leaderboard.stage.gazago.io';
      case Flavor.stage:
        return 'https://leaderboard.stage.gazago.io';
      case Flavor.prod:
        return 'https://leaderboard.gazago.io';
      default:
        return 'https://leaderboard.stage.gazago.io';
    }
  }

  static Ed25519HDPublicKey get solanaFeePayer {
    switch (appFlavor) {
      case Flavor.dev:
        return Ed25519HDPublicKey.fromBase58(
            "E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
      case Flavor.stage:
        return Ed25519HDPublicKey.fromBase58(
            "E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
      case Flavor.prod:
        return Ed25519HDPublicKey.fromBase58(
            "jfMvdqtgQ4VnnhYgHEa1KEQSobiqy7dAFepr1CZRZ4A");
      default:
        return Ed25519HDPublicKey.fromBase58(
            "E3hFsYympX61jvzMuJjrQ7bJkqpUXqc1F7q3QCGsF9ui");
    }
  }

  static Ed25519HDPublicKey get solanaTokenMint {
    switch (appFlavor) {
      case Flavor.dev:
        return Ed25519HDPublicKey.fromBase58(
            "7sc5sRrmPC3oz8rq1cJn28GGr2ezqeBLNEjy8LXkHY9U");
      case Flavor.stage:
        return Ed25519HDPublicKey.fromBase58(
            "7sc5sRrmPC3oz8rq1cJn28GGr2ezqeBLNEjy8LXkHY9U");
      case Flavor.prod:
        return Ed25519HDPublicKey.fromBase58(
            "8BMzMi2XxZn9afRaMx5Z6fauk9foHXqV5cLTCYWRcVje");
      default:
        return Ed25519HDPublicKey.fromBase58(
            "7sc5sRrmPC3oz8rq1cJn28GGr2ezqeBLNEjy8LXkHY9U");
    }
  }

  static Ed25519HDPublicKey get solanaTokenMasterWallet {
    switch (appFlavor) {
      case Flavor.dev:
        return Ed25519HDPublicKey.fromBase58(
            "6ShEHhBuv6VNNQy4Tw4jYBS6Rq99gNBRHpQ5HDkTfvdy");
      case Flavor.stage:
        return Ed25519HDPublicKey.fromBase58(
            "6ShEHhBuv6VNNQy4Tw4jYBS6Rq99gNBRHpQ5HDkTfvdy");
      case Flavor.prod:
        return Ed25519HDPublicKey.fromBase58(
            "Stik9LuN3nE7wB7tiKZMMNX7JuhY9fRrSWS8EU6RBMu");
      default:
        return Ed25519HDPublicKey.fromBase58(
            "6ShEHhBuv6VNNQy4Tw4jYBS6Rq99gNBRHpQ5HDkTfvdy");
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

  static String get dailyBenefitAd1Ios {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/6978759866';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/6978759866';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/3997694956';
      default:
        return 'ca-app-pub-3940256099942544/6978759866';
    }
  }

  static String get dailyBenefitAd1Android {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/5354046379';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/5354046379';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/6128284879';
      default:
        return 'ca-app-pub-3940256099942544/5354046379';
    }
  }

  static String get dailyBenefitMetaAdAndroid {
    switch (appFlavor) {
      case Flavor.dev:
        return '1370832760528609_1370834690528416';
      case Flavor.stage:
        return '1370832760528609_1370834690528416';
      case Flavor.prod:
        return '1370832760528609_1370834690528416';
      default:
        return '1370832760528609_1370834690528416';
    }
  }

  static String get dailyBenefitMetaAdIos {
    switch (appFlavor) {
      case Flavor.dev:
        return '1370832760528609_1370873647191187';
      case Flavor.stage:
        return '1370832760528609_1370873647191187';
      case Flavor.prod:
        return '1370832760528609_1370873647191187';
      default:
        return '1370832760528609_1370873647191187';
    }
  }

  static String get dailyBenefitAd2Ios {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/1712485313';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/3194013355';
      default:
        return 'ca-app-pub-3940256099942544/1712485313';
    }
  }

  static String get dailyBenefitAd2Android {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.stage:
        return 'ca-app-pub-3940256099942544/5224354917';
      case Flavor.prod:
        return 'ca-app-pub-4234536720874912/9567850011';
      default:
        return 'ca-app-pub-3940256099942544/5224354917';
    }
  }

  static String get webWalletUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://wallet.stage.staika.io';
      case Flavor.stage:
        // return 'http://192.168.88.241:3000';
        return 'https://wallet.stage.staika.io';
      case Flavor.prod:
        return 'https://wallet.staika.io';
      default:
        return 'https://wallet.stage.staika.io';
    }
  }
}
