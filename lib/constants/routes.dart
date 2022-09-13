import 'package:get/get_navigation/get_navigation.dart';
import 'package:step_go/presentations/views/archive/archive_detail.dart';
import 'package:step_go/presentations/views/home.dart';
import 'package:step_go/presentations/views/join/join_terms.dart';
import 'package:step_go/presentations/views/login.dart';
import 'package:step_go/presentations/views/on_boarding.dart';
import 'package:step_go/presentations/views/preferences/notification_alert.dart';
import 'package:step_go/presentations/views/preferences/preference_board.dart';
import 'package:step_go/presentations/views/preferences/preferences.dart';
import 'package:step_go/presentations/views/term.dart';
import 'package:step_go/presentations/views/verification/index.dart';

class Routes {
  static const login = '/login';
  static const onBoarding = '/on_boarding';
  static const joinTerms = '/join_terms';
  static const home = '/home';
  static const term = '/term/:termType';
  static const archiveDetail = '/archive/detail';
  static const preferences = '/preferences';
  static const preferenceBoard = '/preferences/board';
  static const preferenceNotification = '/preferences/notification';
  static const verification = '/verification';

  static List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const Login()),
    GetPage(name: Routes.onBoarding, page: () => const OnBoarding()),
    GetPage(name: Routes.joinTerms, page: () => const JoinTerms()),
    GetPage(name: Routes.home, page: () => const Home()),
    GetPage(name: Routes.term, page: () => const Term()),
    GetPage(name: Routes.archiveDetail, page: () => const ArchiveDetail()),
    GetPage(name: Routes.preferences, page: () => const Preferences()),
    GetPage(name: Routes.preferenceBoard, page: () => const PreferenceBoard()),
    GetPage(
        name: Routes.preferenceNotification,
        page: () => const NotificationAlert()),
    GetPage(name: Routes.verification, page: () => const Verification()),
  ];
}
