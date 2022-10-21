import 'package:flutter/material.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/middleware/router_middleware.dart';
import 'package:gaza_go/presentations/views/activity/activity_active.dart';
import 'package:gaza_go/presentations/views/activity/activity_challenges.dart';
import 'package:gaza_go/presentations/views/activity/activity_loading.dart';
import 'package:gaza_go/presentations/views/archive/archive_detail.dart';
import 'package:gaza_go/presentations/views/auth/account_restore.dart';
import 'package:gaza_go/presentations/views/auth/signup_complete.dart';
import 'package:gaza_go/presentations/views/home.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge_detail.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item_detail.dart';
import 'package:gaza_go/presentations/views/inventory/synthetic_badge.dart';
import 'package:gaza_go/presentations/views/join/join_terms.dart';
import 'package:gaza_go/presentations/views/leaderboard/calendar_statistics.dart';
import 'package:gaza_go/presentations/views/loading.dart';
import 'package:gaza_go/presentations/views/login.dart';
import 'package:gaza_go/presentations/views/on_boarding.dart';
import 'package:gaza_go/presentations/views/preferences/edit_biometrics.dart';
import 'package:gaza_go/presentations/views/preferences/index.dart';
import 'package:gaza_go/presentations/views/preferences/my_page.dart';
import 'package:gaza_go/presentations/views/preferences/notification_alert.dart';
import 'package:gaza_go/presentations/views/preferences/preference_board.dart';
import 'package:gaza_go/presentations/views/preferences/withdraw_completed.dart';
import 'package:gaza_go/presentations/views/preferences/withdraw_confirm.dart';
import 'package:gaza_go/presentations/views/term.dart';
import 'package:gaza_go/presentations/views/verification/index.dart';
import 'package:gaza_go/presentations/views/wallet/buy_tik.dart';
import 'package:gaza_go/presentations/views/wallet/index.dart';
import 'package:gaza_go/presentations/views/wallet/wallet_actions.dart';
import 'package:gaza_go/presentations/views/wallet/wallet_detail.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Routes {
  static const login = '/login';
  static const onBoarding = '/on_boarding';
  static const joinTerms = '/join_terms';
  static const loading = '/loading';
  static const home = '/home';
  static const term = '/term/:termType';
  static const archiveDetail = '/archive/detail';
  static const activityChallenges = '/activity/challenges';
  static const activityLoading = '/activity/loading';
  static const activityActive = '/activity/active';
  static const preferences = '/preferences';
  static const preferenceBoard = '/preferences/board';
  static const preferenceNotification = '/preferences/notification';
  static const verification = '/verification';
  static const myPage = '/my_page';
  static const editBiometrics = '/my_page/edit_biometrics';
  static const withdrawConfirm = '/my_page/withdraw';
  static const withdrawCompleted = '/my_page/withdraw_completed';
  static const wallet = '/wallet';
  static const buyTik = '/wallet/buy_tik';
  static const walletDetail = '/wallet/detail';
  static const walletActions = '/wallet/action';
  static const inventory = '/inventory';
  static const itemDetail = '/inventory/item/detail';
  static const badgeDetail = '/inventory/badge/detail';
  static const syntheticBadge = '/inventory/synthetic_badge';
  static const calendarStatistics = '/leaderboard/calendar_statistics';
  static const signupComplete = '/auth/signup_complete';
  static const accountRestore = '/account/restore';

  static List<GetPage> pages = [
    stepPage(name: Routes.login, page: const Login()),
    stepPage(name: Routes.onBoarding, page: const OnBoarding()),
    stepPage(name: Routes.joinTerms, page: const JoinTerms()),
    stepPage(name: Routes.loading, page: const Loading()),
    stepPage(
      name: Routes.home,
      page: const Home(),
      transition: Transition.noTransition,
    ),
    stepPage(name: Routes.term, page: const Term()),
    stepPage(name: Routes.archiveDetail, page: const ArchiveDetail()),
    stepPage(name: Routes.activityChallenges, page: const ActivityChallenges()),
    stepPage(name: Routes.activityLoading, page: const ActivityLoading()),
    stepPage(name: Routes.activityActive, page: const ActivityActive()),
    stepPage(
      name: Routes.preferences,
      page: const Preferences(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    stepPage(name: Routes.preferenceBoard, page: const PreferenceBoard()),
    stepPage(name: Routes.preferenceNotification, page: const NotificationAlert()),
    stepPage(name: Routes.verification, page: const Verification()),
    stepPage(name: Routes.myPage, page: const MyPage()),
    stepPage(name: Routes.editBiometrics, page: const EditBiometrics()),
    stepPage(name: Routes.withdrawConfirm, page: const WithdrawConfirm()),
    stepPage(name: Routes.withdrawCompleted, page: const WithdrawCompleted()),
    stepPage(name: Routes.wallet, page: const WalletHome()),
    stepPage(name: Routes.walletDetail, page: const WalletDetail()),
    stepPage(name: Routes.buyTik, page: BuyTik()),
    stepPage(name: Routes.walletActions, page: const WalletActions()),
    stepPage(name: Routes.inventory, page: const InventoryHome()),
    stepPage(name: Routes.itemDetail, page: const InventoryItemDetail()),
    stepPage(name: Routes.badgeDetail, page: const InventoryBadgeDetail()),
    stepPage(name: Routes.syntheticBadge, page: const SyntheticBadge()),
    stepPage(name: Routes.calendarStatistics, page: const CalendarStatistics()),
    stepPage(name: Routes.signupComplete, page: const SignupComplete()),
    stepPage(name: Routes.accountRestore, page: const AccountRestore()),
  ];
}

GetPage stepPage({required String name, required Widget page, Transition? transition, Duration? transitionDuration, List<GetMiddleware>? middlewares}) {
  return GetPage(name: name, page: () => _flavorBanner(child: page, show: F.name != 'prod'), transition: transition, transitionDuration: transitionDuration, middlewares: [
    AuthMiddleware(),
  ]);
}

Widget _flavorBanner({
  required Widget child,
  bool show = true,
}) =>
    show
        ? Banner(
            location: BannerLocation.topStart,
            message: F.name,
            color: Colors.green.withOpacity(0.6),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
            textDirection: TextDirection.ltr,
            child: child,
          )
        : Container(
            child: child,
          );
