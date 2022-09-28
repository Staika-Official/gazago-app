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
