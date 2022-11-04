import 'package:gaza_go/constants/base_urls.dart';

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
        return '가자GO-dev';
      case Flavor.stage:
        return '가자GO-stage';
      case Flavor.prod:
        return '가자GO';
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
}
