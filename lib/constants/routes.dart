import 'package:get/get_navigation/get_navigation.dart';
import 'package:step_go/presentations/views/home.dart';
import 'package:step_go/presentations/views/inventory/inventory_home.dart';
import 'package:step_go/presentations/views/join/join_terms.dart';
import 'package:step_go/presentations/views/login.dart';
import 'package:step_go/presentations/views/on_boarding.dart';

class Routes {
  static const login = '/login';
  static const onBoarding = '/on_boarding';
  static const joinTerms = '/join_terms';
  static const home = '/home';
  static const inventory = '/inventory';

  static List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const Login()),
    GetPage(name: Routes.onBoarding, page: () => const OnBoarding()),
    GetPage(name: Routes.joinTerms, page: () => JoinTerms()),
    GetPage(name: Routes.home, page: () => const Home()),
    GetPage(name: Routes.inventory, page: () => InventoryHome()),
  ];
}
