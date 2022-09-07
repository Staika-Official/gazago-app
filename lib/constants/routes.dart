import 'package:get/get_navigation/get_navigation.dart';
import 'package:step_go/presentations/views/archive/index.dart';
import 'package:step_go/presentations/views/home.dart';
import 'package:step_go/presentations/views/inventory/index.dart';
import 'package:step_go/presentations/views/join/join_terms.dart';
import 'package:step_go/presentations/views/leaderboard/index.dart';
import 'package:step_go/presentations/views/login.dart';
import 'package:step_go/presentations/views/on_boarding.dart';
import 'package:step_go/presentations/views/shop/index.dart';
import 'package:step_go/presentations/views/term.dart';

class Routes {
  static const login = '/login';
  static const onBoarding = '/on_boarding';
  static const joinTerms = '/join_terms';
  static const home = '/home';
  static const term = '/term/:termType';
  static const archiveHome = '/archive';
  static const inventoryHome = '/inventory';
  static const shopHome = '/shop';
  static const leaderboardHome = '/leaderboard';

  static List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const Login()),
    GetPage(name: Routes.onBoarding, page: () => const OnBoarding()),
    GetPage(name: Routes.joinTerms, page: () => const JoinTerms()),
    GetPage(name: Routes.home, page: () => const Home(), transition: Transition.noTransition),
    GetPage(name: Routes.term, page: () => const Term()),
    GetPage(name: Routes.archiveHome, page: () => const ArchiveHome(), transition: Transition.noTransition),
    GetPage(name: Routes.inventoryHome, page: () => const InventoryHome(), transition: Transition.noTransition),
    GetPage(name: Routes.shopHome, page: () => const ShopHome(), transition: Transition.noTransition),
    GetPage(name: Routes.leaderboardHome, page: () => const LeaderboardHome(), transition: Transition.noTransition),
  ];
}
