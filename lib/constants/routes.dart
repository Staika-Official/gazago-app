import 'package:flutter/material.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/middleware/router_middleware.dart';
import 'package:gaza_go/presentations/views/activity/activity_active.dart';
import 'package:gaza_go/presentations/views/activity/activity_courses.dart';
import 'package:gaza_go/presentations/views/activity/challenge_course_detail.dart';
import 'package:gaza_go/presentations/views/activity/challenge_map.dart';
import 'package:gaza_go/presentations/views/activity/equipped_item.dart';
import 'package:gaza_go/presentations/views/activity/fair_play_view.dart';
import 'package:gaza_go/presentations/views/archive/archive_detail.dart';
import 'package:gaza_go/presentations/views/auth/account_restore.dart';
import 'package:gaza_go/presentations/views/auth/signup_complete.dart';
import 'package:gaza_go/presentations/views/challenges/challenge_detail.dart';
import 'package:gaza_go/presentations/views/daily_benefits.dart';
import 'package:gaza_go/presentations/views/debugging/position_raw_data_logs.dart';
import 'package:gaza_go/presentations/views/debugging/request_info.dart';
import 'package:gaza_go/presentations/views/debugging/response_error_logs.dart';
import 'package:gaza_go/presentations/views/debugging/user_exercise_data_logs.dart';
import 'package:gaza_go/presentations/views/home.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge_detail.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item_detail.dart';
import 'package:gaza_go/presentations/views/inventory/synthetic_badge.dart';
import 'package:gaza_go/presentations/views/join/join_terms.dart';
import 'package:gaza_go/presentations/views/laboratory/laboratory_end_point.dart';
import 'package:gaza_go/presentations/views/laboratory/laboratory_fake_gps.dart';
import 'package:gaza_go/presentations/views/laboratory/laboratory_solana_create_wallet.dart';
import 'package:gaza_go/presentations/views/laboratory/laboratory_solana_transfer.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:gaza_go/presentations/views/loading.dart';
import 'package:gaza_go/presentations/views/login.dart';
import 'package:gaza_go/presentations/views/on_boarding.dart';
import 'package:gaza_go/presentations/views/permissions.dart';
import 'package:gaza_go/presentations/views/preferences/edit_biometrics.dart';
import 'package:gaza_go/presentations/views/preferences/index.dart';
import 'package:gaza_go/presentations/views/preferences/my_page.dart';
import 'package:gaza_go/presentations/views/preferences/notice_detail.dart';
import 'package:gaza_go/presentations/views/preferences/notice_list.dart';
import 'package:gaza_go/presentations/views/preferences/notifications.dart';
import 'package:gaza_go/presentations/views/preferences/preference_board.dart';
import 'package:gaza_go/presentations/views/preferences/terms_list.dart';
import 'package:gaza_go/presentations/views/preferences/withdraw_completed.dart';
import 'package:gaza_go/presentations/views/preferences/withdraw_confirm.dart';
import 'package:gaza_go/presentations/views/shop/shop_item_detail.dart';
import 'package:gaza_go/presentations/views/term.dart';
import 'package:gaza_go/presentations/views/verification/verification_cert_code.dart';
import 'package:gaza_go/presentations/views/verification/verification_detail.dart';
import 'package:gaza_go/presentations/views/verification/verification_name.dart';
import 'package:gaza_go/presentations/views/verification/verification_phone.dart';
import 'package:gaza_go/presentations/views/wallet/buy_tik.dart';
import 'package:gaza_go/presentations/views/wallet/create_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/create_wallet_password.dart';
import 'package:gaza_go/presentations/views/wallet/index.dart';
import 'package:gaza_go/presentations/views/wallet/send_stik_go_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/taika_pay.dart';
import 'package:gaza_go/presentations/views/wallet/wallet_actions.dart';
import 'package:gaza_go/presentations/views/wallet/wallet_detail.dart';
import 'package:gaza_go/presentations/views/webview.dart';
import 'package:get/get.dart';

import '../presentations/views/debugging/activity_logs.dart';
import '../presentations/views/laboratory/index.dart';
import '../presentations/views/verification/verification_terms.dart';

class Routes {
  static const login = '/login';
  static const onBoarding = '/on_boarding';
  static const joinTerms = '/join_terms/:platform';
  static const loading = '/loading';
  static const home = '/home';
  static const term = '/term/:platform/:termType/:termId';
  static const termsList = '/terms_list';
  static const archiveDetail = '/archive/detail';
  static const activityChallenges = '/activity/challenges';
  static const activityLoading = '/activity/loading';
  static const activityActive = '/activity/active';
  static const equippedItems = '/activity/equipped_items';
  static const challengeMap = '/activity/challenge_map';
  static const preferences = '/preferences';
  static const preferenceBoard = '/preferences/board';
  static const noticeList = '/notice/list';
  static const noticeDetail = '/notice/detail';
  static const notifications = '/preferences/notifications';
  static const verification = '/verification';
  static const verificationTerms = '/verification/terms';
  static const verificationName = '/verification/name';
  static const verificationDetail = '/verification/detail';
  static const verificationPhone = '/verification/phone';
  static const verificationCertCode = '/verification/cert_code';
  static const myPage = '/my_page';
  static const editBiometrics = '/my_page/edit_biometrics';
  static const withdrawConfirm = '/my_page/withdraw';
  static const withdrawCompleted = '/my_page/withdraw_completed';
  static const wallet = '/wallet';
  static const buyTik = '/wallet/buy_tik';
  static const walletDetail = '/wallet/detail';
  static const walletActions = '/wallet/action';
  static const taikaPay = '/wallet/taika_pay';
  static const inventory = '/inventory';
  static const itemDetail = '/inventory/item/detail';
  static const badgeDetail = '/inventory/badge/detail';
  static const syntheticBadge = '/inventory/synthetic_badge';
  static const signupComplete = '/auth/signup_complete';
  static const accountRestore = '/account/restore';
  static const permissions = '/permissions';
  static const requestInfo = '/debugging/request_info';
  static const activityLogs = '/debugging/activity_logs';
  static const responseErrorLogs = '/debugging/response_error_logs';
  static const userExerciseDataLogs = '/debugging/user_exercise_data_logs';
  static const positionRawDataLogs = '/debugging/position_raw_data_logs';
  static const laboratory = '/laboratory';
  static const laboratorySolanaCreateWallet = '/laboratory/laboratory_solana_create_wallet';
  static const laboratorySolanaTransfer = '/laboratory/laboratory_solana_transfer';
  static const laboratoryEndPoint = '/laboratory/end_point';
  static const laboratoryFakeGps = '/laboratory/fake_gps';
  static const shopItemDetail = '/shop/item/detail';
  static const adMobRewarded = '/admob/reward';
  static const adMobRewardedInterstitial = '/admob/interstitial';
  static const webView = '/webview/:id';
  static const createWalletPassword = '/wallet/create/password';
  static const createWallet = '/wallet/create';
  static const sendStikGoWallet = '/wallet/send_stik_go_wallet';
  static const challengeDetail = '/challenges/challenge_detail';
  static const challengeCourseDetail = '/activity/challenge_course_detail';
  static const leaderboard = '/leaderboard';
  static const fairPlayView = '/fair_play_view';
  static const dailyBenefits = '/daily_benefits';

  static List<GetPage> pages = [
    stepPage(name: Routes.login, page: const Login()),
    stepPage(name: Routes.onBoarding, page: const OnBoarding()),
    stepPage(name: Routes.joinTerms, page: const JoinTerms()),
    stepPage(
        name: Routes.loading,
        page: const Loading(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoadingController>(() => LoadingController());
        })),
    stepPage(
      name: Routes.home,
      page: const Home(),
      transition: Transition.noTransition,
    ),
    stepPage(name: Routes.term, page: const Term()),
    stepPage(name: Routes.termsList, page: const TermsList()),
    stepPage(name: Routes.archiveDetail, page: const ArchiveDetail()),
    stepPage(name: Routes.activityChallenges, page: const ActivityChallengeCourses()),
    stepPage(name: Routes.activityActive, page: const ActivityActive()),
    stepPage(name: Routes.challengeMap, page: const ChallengeMap()),
    stepPage(name: Routes.preferences, page: const Preferences()),
    stepPage(name: Routes.preferenceBoard, page: const PreferenceBoard()),
    stepPage(name: Routes.noticeList, page: const NoticeList()),
    stepPage(name: Routes.noticeDetail, page: const NoticeDetail()),
    stepPage(name: Routes.notifications, page: const Notifications()),
    stepPage(name: Routes.verificationTerms, page: const VerificationTerms()),
    stepPage(name: Routes.verificationName, page: const VerificationName()),
    stepPage(name: Routes.verificationDetail, page: const VerificationDetail()),
    stepPage(name: Routes.verificationPhone, page: const VerificationPhone()),
    stepPage(name: Routes.verificationCertCode, page: const VerificationCertCode()),
    stepPage(name: Routes.myPage, page: const MyPage()),
    stepPage(name: Routes.editBiometrics, page: const EditBiometrics()),
    stepPage(name: Routes.withdrawConfirm, page: const WithdrawConfirm()),
    stepPage(name: Routes.withdrawCompleted, page: const WithdrawCompleted()),
    stepPage(name: Routes.wallet, page: const WalletHome()),
    stepPage(name: Routes.walletDetail, page: const WalletDetail()),
    stepPage(name: Routes.buyTik, page: const BuyTik()),
    stepPage(name: Routes.walletActions, page: const WalletActions()),
    stepPage(name: Routes.taikaPay, page: const TaikaPay()),
    stepPage(name: Routes.inventory, page: const InventoryHome()),
    stepPage(name: Routes.itemDetail, page: const InventoryItemDetail()),
    stepPage(name: Routes.badgeDetail, page: const InventoryBadgeDetail()),
    stepPage(name: Routes.syntheticBadge, page: const SyntheticBadge()),
    stepPage(name: Routes.signupComplete, page: const SignupComplete()),
    stepPage(name: Routes.accountRestore, page: const AccountRestore()),
    stepPage(name: Routes.equippedItems, page: const EquippedItems()),
    stepPage(name: Routes.permissions, page: Permissions()),
    stepPage(name: Routes.requestInfo, page: const RequestInfo()),
    stepPage(name: Routes.responseErrorLogs, page: const ResponseErrorLogs()),
    stepPage(name: Routes.activityLogs, page: const ActivityLogs()),
    stepPage(name: Routes.userExerciseDataLogs, page: const UserExerciseDataLogs()),
    stepPage(name: Routes.positionRawDataLogs, page: const PositionRawDataLogs()),
    stepPage(name: Routes.shopItemDetail, page: const ShopItemDetail()),
    stepPage(name: Routes.laboratory, page: const Laboratory()),
    stepPage(name: Routes.laboratorySolanaCreateWallet, page: const LaboratorySolanaCreateWallet()),
    stepPage(name: Routes.laboratorySolanaTransfer, page: const LaboratorySolanaTransfer()),
    stepPage(name: Routes.webView, page: const WebView()),
    stepPage(name: Routes.laboratoryEndPoint, page: const LaboratoryEndPoint()),
    stepPage(name: Routes.laboratoryFakeGps, page: const LaboratoryFakeGps()),
    stepPage(name: Routes.createWalletPassword, page: const CreateWalletPassword()),
    stepPage(name: Routes.createWallet, page: const CreateWallet()),
    stepPage(name: Routes.sendStikGoWallet, page: const SendStikGoWallet()),
    stepPage(name: Routes.challengeDetail, page: const ChallengeDetail()),
    stepPage(name: Routes.challengeCourseDetail, page: const ChallengeCourseDetail()),
    stepPage(name: Routes.leaderboard, page: const RankingHome()),
    stepPage(name: Routes.fairPlayView, page: const FairPlayView()),
    stepPage(name: Routes.dailyBenefits, page: const DailyBenefits()),
  ];
}

GetPage stepPage({required String name, required Widget page, Transition? transition, Duration? transitionDuration, List<GetMiddleware>? middlewares, BindingsBuilder? binding}) {
  return GetPage(
      name: name,
      page: () => _flavorBanner(child: page, show: F.name != 'prod'),
      transition: transition,
      transitionDuration: transitionDuration,
      middlewares: [
        AuthMiddleware(),
      ],
      binding: binding);
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
