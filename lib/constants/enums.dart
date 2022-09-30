enum LoginType {
  kakao,
  google,
  apple,
  email,
}

enum ExerciseType {
  hiking,
  walking,
}

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
  fcmToken,
  accessToken,
  refreshToken,
  userId,
  profileImageUrl,
  nickname,
  locationData,
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
  rechargeTik,
}

extension PaymentPurposeLabel on PaymentPurpose {
  String get label {
    switch (this) {
      case PaymentPurpose.rechargeStamina:
        return '체력충전';
      case PaymentPurpose.rechargeDurability:
        return '내구도충전';
      case PaymentPurpose.repairItem:
        return '아이템수리';
      case PaymentPurpose.buyItem:
        return '아이템구매';
      case PaymentPurpose.badgeSynthesize:
        return '배지합성';
      case PaymentPurpose.buyBadge:
        return '배지구매';
      case PaymentPurpose.rechargeTik:
        return 'TIK충전';
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
