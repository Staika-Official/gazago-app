class BaseUrl {
  // static const String dev = 'http://10.0.2.2:8080';
  static const String dev = 'http://api.dev.staika.io:8080';
  // static const String dev = 'http://ci-ext.staika.io:8081';
  static const String stage = 'https://api.stage.staika.io';
  static const String prod = 'https://api.staika.io';
}

class ServiceUrl {
  static const String uaaService = '/services/uaa/api';
  static const String itemService = '/services/gazago/api/user-items';
  static const String badgeService = '/services/gazago/api/user-badges';
  static const String memberService = '/services/member';
  static const String stateService = '/services/gazago/api/user-states';
  static const String exerciseService = '/services/gazago/api/user-exercises';
  static const String staminaService = '/services/gazago/api/user-state-recoveries';
  static const String dashboardV2Service = '/services/gazago/api/v2/dash-board-reward-dailies';
  static const String dashboardService = '/services/gazago/api/dash-board-reward-dailies';
  static const String goWalletService = '/services/wallet-go/api';
  static const String onChainWalletService = '/services/wallet-go/api/on-chains';
  static const String boardService = '/services/board/api';
  static const String shopService = '/services/gazago/api/shop';
  static const String shop2Service = '/services/gazago/api/v2/shop';
  static const String admobService = '/services/gazago/api/ad-admob-rewards';
  static const String dailyBenefitsService = '/services/gazago/api/benefits';
}
