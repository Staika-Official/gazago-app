class InitExerciseEvent {}

class MoveToWalletEvent {}

class ResetItemsTabMenuEvent {}

class InitializeActivityControllerEvent {}

class InitializeWalletMasterControllerEvent {}

class RefreshChallengeControllerEvent {}

class RefreshInventoryControllerEvent {}

class RefreshActivityControllerEvent {}

class RefreshShopControllerEvent {}

class RefreshArchiveControllerEvent {}

class RefreshLeaderboardControllerEvent {}

class HandleAlreadyFinishedExerciseEvent {}

class SetHomeTabMenuEvent {
  int index;

  SetHomeTabMenuEvent(this.index);
}

class SetBottomNavStateEvent {
  bool isShow;

  SetBottomNavStateEvent(this.isShow);
}

class UpdateProgressEvent {
  String message;

  UpdateProgressEvent(this.message);
}

class SetLeaderboardTabMenuEvent {
  int index;

  SetLeaderboardTabMenuEvent(this.index);
}

class GetUserStateEvent {}

class GetSpendingWalletBalancesEvent {}

class CalculateItemTabHeightEvent {
  int tabIndex;
  String itemType;

  CalculateItemTabHeightEvent(this.tabIndex, this.itemType);
}

class GetProfileInfoEvent {}

class GetShopItemsListEvent {}

class GetStikPriceInfoEvent {}

class SetLoaderEvent {
  bool isShow;

  SetLoaderEvent(this.isShow);
}

class GetStaikaWalletInfoEvent {}
