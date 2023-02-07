enum LoginType {
  apple,
  google,
  // email,
}

enum ExerciseType {
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
  badgeIssuanceRequested,
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
  positionLowDataLogs,
  needRouteToGoWallet,
  needToForceLogout,
  hasForcedLogout,
  solanaSecretKey,
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
        return '초기화 완료';
      case ExerciseState.ready:
        return '운동 준비중';
      case ExerciseState.ongoing:
        return '운동 중';
      case ExerciseState.paused:
        return '운동 휴식 중';
      case ExerciseState.finished:
        return '운동 완료';
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
        return 'RECHARGE_STAMINA'; // '체력충전';
      case PaymentPurpose.rechargeDurability:
        return 'RECHARGE_DURABILITY'; // '내구도충전';
      case PaymentPurpose.repairItem:
        return 'REPAIR_ITEM'; // '아이템수리';
      case PaymentPurpose.buyItem:
        return 'BUY_BADGE'; // '아이템구매';
      case PaymentPurpose.badgeSynthesize:
        return 'BUY_ITEM'; // '배지합성';
      case PaymentPurpose.buyBadge:
        return 'COMPOSE_BADGE'; // '배지구매';
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
        return 'SKT 알뜰폰';
      case MobileCompany.kt_cheap:
        return 'KT 알뜰폰';
      case MobileCompany.lg_cheap:
        return 'LG U+ 알뜰폰';
    }
  }
}
