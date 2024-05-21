import 'dart:async';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin AdmobMixin {
  Rx<RewardedAd?> startAd = Rx(null);
  Rx<RewardedAd?> endAd = Rx(null);
  Timer? adTimer;
  final RxInt adLoadingTime = RxInt(5);
  String? advertisingId = '';
  bool? isLimitAdTrackingEnabled;

  RxMap<String, int> adLoadAttempts = RxMap({
    "exerciseStartAd": 0,
    "exerciseEndAd": 0,
  });

  RxString selectedAd = RxString('');
  RxBool isLoadedAd = RxBool(false);
  bool adUpdateLocked = false;

  Future handleSelectAdType(adType) async {
    selectedAd.value = adType;
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      advertisingId = await AdvertisingId.id(true);
    } on PlatformException {
      advertisingId = 'Failed to get platform version.';
    }

    try {
      isLimitAdTrackingEnabled = await AdvertisingId.isLimitAdTrackingEnabled;
    } on PlatformException {
      isLimitAdTrackingEnabled = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    advertisingId = advertisingId;
    isLimitAdTrackingEnabled = isLimitAdTrackingEnabled;
  }

  void adLoadTimerStart() {
    adLoadingTime.value = 5;
    adUpdateLocked = false;

    if (adTimer != null && adLoadingTime.value < 0) {
      adTimer = null;
      adLoadingTime.value = 5;
    }

    adTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      adLoadingTime.value--;

      if (startAd.value != null || endAd.value != null) {
        timer.cancel();
        adTimer = null;
      }

      if (adLoadingTime.value == 0 || adLoadingTime.value < 0) {
        adUpdateLocked = true;
        timer.cancel();
        adTimer = null;
      }
    });
  }

  void adLoadTimerStop() {
    if (adTimer != null) {
      adTimer?.cancel();
      adTimer = null;
    }
  }

  // 운동 시작 광고
  void exerciseStartRewardedAdInit(String adType, {Function? successCallback, Function? errorCallback}) async {
    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isIOS ? F.startAdIos : F.startAdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (!adUpdateLocked) {
            startAd.value = ad;
          }
          isLoadedAd.value = true;
          adLoadAttempts[adType] = 0;
          if (successCallback != null) successCallback();
        },
        onAdFailedToLoad: (error) {
          startAd.value = null;
          isLoadedAd.value = false;
          adLoadAttempts[adType] = adLoadAttempts[adType]! + 1;
          if (errorCallback != null) errorCallback();
        },
      ),
    );
  }

  // 운동 종료 광고
  Future exerciseEndRewardedAdInit(String adType, {Function? successCallback, Function? errorCallback}) async {
    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isIOS ? F.endAdIos : F.endAdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (!adUpdateLocked) {
            endAd.value = ad;
          }
          adLoadAttempts[adType] = 0;

          if (successCallback != null) successCallback();
          // numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          endAd.value = null;
          adLoadAttempts[adType] = adLoadAttempts[adType]! + 1;
          if (errorCallback != null) errorCallback();
        },
      ),
    );
  }

  void showExerciseStartAd(ActivityController activityController, String adType) {
    if (startAd.value == null) {
      return;
    }
    startAd.value!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // if (ad.adUnitId.isNotEmpty) {
        //
        // }
        activityController.handleMoveExerciseActive(activityController.selectedExerciseType.value);
        startAd.value = null;
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
      },
    );

    startAd.value!.setImmersiveMode(true);
    startAd.value!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      // DateTime now = DateTime.now();
      // HiveStore.save(key: 'exerciseStartAd', value: now);
    });
    Timer(const Duration(milliseconds: 300), () {
      startAd.value = null;
    });
  }

  void showExerciseEndAd(ActivityController activityController) async {
    // String endAdName =
    //     await checkActivityType(selectedAd.value);

    if (endAd.value == null) {
      return;
    }
    endAd.value!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // if (ad.adUnitId.isNotEmpty) {
        //   activityController.endExercise(source: 'showEndADExerciseAlert', adId: ad.adUnitId);
        //   endAd.value = null;
        //   activityController.adLoadingTime.value = 0;
        // }

        activityController.endExercise(source: 'showEndADExerciseAlert');
        endAd.value = null;
        // activityController.adLoadingTime.value = 0;

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
      },
    );

    endAd.value!.setImmersiveMode(true);
    endAd.value!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      // DateTime now = DateTime.now();
      // HiveStore.save(key: 'exerciseEndAd', value: now);
    });
    Timer(const Duration(milliseconds: 300), () {
      endAd.value = null;
    });
  }
}
