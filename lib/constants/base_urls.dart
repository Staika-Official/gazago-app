class BaseUrl {
  static const String dev = 'http://api.dev.staika.io:8080';
  // static const String dev = 'http://ci-ext.staika.io:8081';
  static const String stage = 'https://api.stage.staika.io';
  static const String prod = 'https://api.staika.io';
}

class ServiceUrl {
  static const String uaaService = '/services/uaa/api';
  static const String itemService = '/services/gazago/api/user-items';
  static const String badgeService = '/services/gazago/api/user-badges';
  static const String memberService = '';
  static const String stateService = '/services/gazago/api/user-states';
  static const String exerciseService = '/services/gazago/api/user-exercises';
  static const String staminaService = '/services/gazago/api/user-state-recoveries';
  static const String dashboardService = '/services/gazago/api/dash-board-reward-dailies';
  static const String spendingWalletService = '/services/gazago-wallet/api/spending';
  static const String solanaWalletService = '/services/gazago-wallet/api/solana';
}
