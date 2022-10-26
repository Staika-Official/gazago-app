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
        return 'StepGo-dev';
      case Flavor.stage:
        return 'StepGo-stage';
      case Flavor.prod:
        return 'StepGo';
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

  static String get kakaoKey {
    switch (appFlavor) {
      case Flavor.dev:
        return '930bba5aed33cd931e3f56280a663785';
      case Flavor.stage:
        return '930bba5aed33cd931e3f56280a663785';
      case Flavor.prod:
        return '2e02e4417b2bc7cdecb41b59d6196206';
      default:
        return '930bba5aed33cd931e3f56280a663785';
    }
  }
}
