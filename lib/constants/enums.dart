import 'package:easy_localization/easy_localization.dart';

enum LoginType {
  apple,
  google,
  // email,
}

enum ExerciseType {
  famous,
  hiking,
  walking,
}

enum Nationality { local, foreigner, none }

extension ExerciseTypeValue on ExerciseType {
  String get value {
    switch (this) {
      case ExerciseType.hiking:
        return 'HIKING';
      case ExerciseType.walking:
        return 'WALKING';
      case ExerciseType.famous:
        return 'FAMOUS_MOUNTAIN_100';
    }
  }
}

enum WalletType {
  inventory,
  asset,
}

enum AssetType {
  token,
  coin,
  nft,
}

enum WalletActionType {
  recharge,
  sendToAsset,
  receive,
  sendToInventory,
  sendOutside,
}

enum HiveKey {
  uuid,
  certified,
  fcmToken,
  accessToken,
  refreshToken,
  userId,
  email,
  profileImageUrl,
  nickname,
  authorities,
  locationData,
  userState,
  exerciseData,
  endExerciseRequested,
  savedStepInitialized,
  savedStepCount,
  dummyStepCount,
  isNewUser,
  permissionRequestOnFirstLaunch,
  isDebuggingMode,
  isShowDebuggingMenu,
  requestLogs,
  responseErrorLogs,
  activityLogs,
  userExerciseDataLogs,
  positionRawDataLogs,
  needRouteToGoWallet,
  needToForceLogout,
  needToForceStopExercise,
  hasForcedLogout,
  exerciseStartAd,
  exerciseEndAd,
  solanaSecretKey,
  closePopupDate,
  closeMaintenancePreviewDate,
  isAccountLocked,
  exerciseTimer,
  updateTimer,
  endPointType,
  walletConnectionPrompted,
  lastUpdatedCoordinateIndex,
  lastUpdatedStepCount,
  lastUpdatedLuckCount,
  exerciseCoordinates,
  allowFakeGpsTest,
  noticePopupListIds,
  courseNotificationList,
  courseNotificationTime,
  hasChallengeSuccessPushMessage,
  luckSound,
  famousChallengeBadgeIssued,
  expirationNotificationState,
  hasSeenFairPlayAlert,
  inviteUserId,
  dynamicLinkRoute,
  adjustFirstWalkingEvent,
  adjustFirstEndedExerciseEvent,
  adjustFirstPurchasedItemEvent,
  adjustFirstEquippedItemEvent,
  adjustFirstJoinedChallengeEvent,
  adjustFirstClickChallengeTabEvent,
  adjustFirstClickRankTabEvent,
  enteredRoute,
  challengeListIds,
  notifiedChallengeList,
  onGetChainWalletBalanceTime,
  bannerAdClick,
  isFailureGetSpendingWallet,
  collectionIdList,
  isNewCollection,
  currentPosition,
  serviceStatus,
  isAlreadySigninUser,
  serviceLanguage,
}

enum ResponseStatus {
  success,
  created,
  unauthorized,
  reLogin,
}

extension ResponseStatusCode on ResponseStatus {
  int get code {
    switch (this) {
      case ResponseStatus.success:
        return 200;
      case ResponseStatus.created:
        return 201;
      case ResponseStatus.unauthorized:
        return 401;
      case ResponseStatus.reLogin:
        return 600;
    }
  }
}

enum ExerciseState {
  init,
  ready,
  ongoing,
  paused,
  finished,
}

extension ExerciseStateLabel on ExerciseState {
  String get label {
    switch (this) {
      case ExerciseState.init:
        return 'init_complete'.tr();
      case ExerciseState.ready:
        return 'exercise_preparing'.tr();
      case ExerciseState.ongoing:
        return 'exercising'.tr();
      case ExerciseState.paused:
        return 'exercise_resting'.tr();
      case ExerciseState.finished:
        return 'exercise_complete'.tr();
    }
  }
}

enum RoundType {
  round,
  ceil,
  floor,
}

enum PaymentPurpose {
  rechargeStamina,
  rechargeDurability,
  repairItem,
  buyItem,
  badgeSynthesize,
  buyBadge,
}

enum Gender { male, female, none }

enum MobileCompany { sk, kt, lg, sk_cheap, kt_cheap, lg_cheap }

extension PaymentPurposeLabel on PaymentPurpose {
  String get label {
    switch (this) {
      case PaymentPurpose.rechargeStamina:
        return 'RECHARGE_STAMINA'; // 'stamina_recharge'.tr();
      case PaymentPurpose.rechargeDurability:
        return 'RECHARGE_DURABILITY'; // 'durability_recharge'.tr();
      case PaymentPurpose.repairItem:
        return 'REPAIR_ITEM'; // 'item_repair'.tr();
      case PaymentPurpose.buyItem:
        return 'BUY_BADGE'; // 'item_purchase'.tr();
      case PaymentPurpose.badgeSynthesize:
        return 'BUY_ITEM'; // 'badge_synthesis'.tr();
      case PaymentPurpose.buyBadge:
        return 'COMPOSE_BADGE'; // 'badge_purchase'.tr();
    }
  }
}

enum Token {
  taika,
  staika,
}

extension TokenMint on Token {
  int get mint {
    switch (this) {
      case Token.taika:
        return 1;
      case Token.staika:
        return 2;
    }
  }
}

enum TransactionConfirmationStatus {
  processed,
  confirmed,
  finalized,
}

enum TransactionType {
  inbound,
  outbound,
  fee,
  unknown,
}

extension TransactionTypeLabel on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.inbound:
        return 'IN'; //입금
      case TransactionType.outbound:
        return 'OUT'; //출금
      case TransactionType.fee:
        return 'FEE'; //수수료출금
      case TransactionType.unknown:
        return 'UNKNOWN'; //알수 없음
    }
  }
}

extension NationalityName on Nationality {
  bool get isForeigner {
    switch (this) {
      case Nationality.local:
      case Nationality.none:
        return false;
      case Nationality.foreigner:
        return true;
    }
  }
}

enum NotificationType {
  challenge,
  badge,
  staminaLow,
  staminaDepleted,
  durabilityLow,
  durabilityDepleted,
  gpsLow,
  normal,
}

extension NotificationId on NotificationType {
  int get id {
    switch (this) {
      case NotificationType.challenge:
        return 0;
      case NotificationType.badge:
        return 1;
      case NotificationType.staminaLow:
      case NotificationType.staminaDepleted:
        return 2;
      case NotificationType.durabilityLow:
      case NotificationType.durabilityDepleted:
        return 3;
      case NotificationType.gpsLow:
        return 4;
      case NotificationType.normal:
        return 5;
    }
  }
}

extension GenderName on Gender {
  String get genderValue {
    switch (this) {
      case Gender.male:
        return 'MALE';
      case Gender.female:
        return 'FEMALE';
      case Gender.none:
        return '';
    }
  }
}

extension MobileCompanyName on MobileCompany {
  String get mobileCompanyName {
    switch (this) {
      case MobileCompany.sk:
        return 'SKT';
      case MobileCompany.kt:
        return 'KT';
      case MobileCompany.lg:
        return 'LG U+';
      case MobileCompany.sk_cheap:
        return 'skt_budget_phone'.tr();
      case MobileCompany.kt_cheap:
        return 'kt_budget_phone'.tr();
      case MobileCompany.lg_cheap:
        return 'lg_u_plus_budget_phone'.tr();
    }
  }
}

enum ItemType {
  all,
  top,
  shoes,
  accessory,
  hat,
  disposable,
  bottom,
}

enum CalendarCellType {
  today,
  focusedDay,
  monthDay,
  outsideDay,
}

enum TransactionStatus {
  highVolatility,
  offerExpired,
  otherErrors,
  success,
  withdrawRequested,
  swapRequested,
  blockchainNetworkError,
}

enum EndPointType {
  dev,
  stage,
  prod,
}

enum Currency { krw, usd }

enum FormStatus { empty, insufficient, sufficient }

enum ErrorStatus { basic, insufficient, notSame, sufficient }

enum ChallengeStatusType {
  participating,
  enter,
  soldout,
  success,
  failure,
  ended,
  beforeOpenEnter,
  beforeOpen,
}

enum ChallengeType { crew, companyCrew, alliance, code, item, payment }

enum ShareSource {
  shareAppbar,
  createCrew,
  crewDetail,
  mirae,
  spot,
}
