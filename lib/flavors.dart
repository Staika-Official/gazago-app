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
}
