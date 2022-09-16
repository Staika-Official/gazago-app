import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:step_go/flavors.dart';
import 'package:step_go/presentations/views/archive/archive_detail.dart';
import 'package:step_go/presentations/views/home.dart';
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

  static List<GetPage> pages = [
    stepPage(name: Routes.login, page: const Login()),
    stepPage(name: Routes.onBoarding, page: const OnBoarding()),
    stepPage(name: Routes.joinTerms, page: const JoinTerms()),
    stepPage(
      name: Routes.home,
      page: Home(),
      transition: Transition.noTransition,
    ),
    stepPage(name: Routes.term, page: const Term()),
    stepPage(name: Routes.archiveDetail, page: const ArchiveDetail()),
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
    stepPage(name: Routes.walletActions, page: const WalletActions()),
  ];
}

GetPage stepPage({required String name, required Widget page, Transition? transition, Duration? transitionDuration}) {
  return GetPage(name: name, page: () => _flavorBanner(child: page, show: F.name != 'prod'), transition: transition, transitionDuration: transitionDuration);
}

Widget _flavorBanner({
  required Widget child,
  bool show = true,
}) =>
    show
        ? Banner(
            child: child,
            location: BannerLocation.topStart,
            message: F.name,
            color: Colors.green.withOpacity(0.6),
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
            textDirection: TextDirection.ltr,
          )
        : Container(
            child: child,
          );
