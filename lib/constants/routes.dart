import 'package:get/get_navigation/get_navigation.dart';
import 'package:step_go/presentations/views/archive/archive_detail.dart';
import 'package:step_go/presentations/views/home.dart';
import 'package:step_go/presentations/views/inventory/inventory_badge_detail.dart';
import 'package:step_go/presentations/views/inventory/synthetic_badge.dart';
import 'package:step_go/presentations/views/join/join_terms.dart';
import 'package:step_go/presentations/views/login.dart';
import 'package:step_go/presentations/views/on_boarding.dart';
import 'package:step_go/presentations/views/preferences/edit_biometrics.dart';
import 'package:step_go/presentations/views/preferences/index.dart';
import 'package:step_go/presentations/views/preferences/my_page.dart';
import 'package:step_go/presentations/views/preferences/notification_alert.dart';
import 'package:step_go/presentations/views/preferences/preference_board.dart';
import 'package:step_go/presentations/views/preferences/withdraw_completed.dart';
import 'package:step_go/presentations/views/preferences/withdraw_confirm.dart';
import 'package:step_go/presentations/views/term.dart';
import 'package:step_go/presentations/views/verification/index.dart';
import 'package:step_go/presentations/views/wallet/index.dart';
import 'package:step_go/presentations/views/wallet/wallet_actions.dart';
import 'package:step_go/presentations/views/wallet/wallet_detail.dart';

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
  static const myPage = '/my_page';
  static const editBiometrics = '/my_page/edit_biometrics';
  static const withdrawConfirm = '/my_page/withdraw';
  static const withdrawCompleted = '/my_page/withdraw_completed';
  static const wallet = '/wallet';
  static const walletDetail = '/wallet/detail';
  static const walletActions = '/wallet/action';
  static const badgeDetail = '/inventory/detail';
  static const syntheticBadge = '/inventory/synthetic_badge';

  static List<GetPage> pages = [
    GetPage(name: Routes.login, page: () => const Login()),
    GetPage(name: Routes.onBoarding, page: () => const OnBoarding()),
    GetPage(name: Routes.joinTerms, page: () => const JoinTerms()),
    GetPage(
      name: Routes.home,
      page: () => Home(),
      transition: Transition.noTransition,
    ),
    GetPage(name: Routes.term, page: () => const Term()),
    GetPage(name: Routes.archiveDetail, page: () => const ArchiveDetail()),
    GetPage(
      name: Routes.preferences,
      page: () => const Preferences(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(name: Routes.preferenceBoard, page: () => const PreferenceBoard()),
    GetPage(name: Routes.preferenceNotification, page: () => const NotificationAlert()),
    GetPage(name: Routes.verification, page: () => const Verification()),
    GetPage(name: Routes.myPage, page: () => const MyPage()),
    GetPage(name: Routes.editBiometrics, page: () => const EditBiometrics()),
    GetPage(name: Routes.withdrawConfirm, page: () => const WithdrawConfirm()),
    GetPage(name: Routes.withdrawCompleted, page: () => const WithdrawCompleted()),
    GetPage(name: Routes.wallet, page: () => const WalletHome()),
    GetPage(name: Routes.walletDetail, page: () => const WalletDetail()),
    GetPage(name: Routes.walletActions, page: () => const WalletActions()),
    GetPage(name: Routes.badgeDetail, page: () => const InventoryBadgeDetail()),
    GetPage(name: Routes.syntheticBadge, page: () => const SyntheticBadge()),
  ];
}
