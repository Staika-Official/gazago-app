import 'dart:async';
import 'dart:io';

import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/challenge_model.dart';

mixin AdmobMixin {
  Rx<RewardedAd?> startAd = Rx(null);
  Rx<RewardedAd?> endAd = Rx(null);

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

  // 운동 시작 광고
  void exerciseStartRewardedAdInit(String adType, {successCallback, errorCallback}) async {
    print(adType);

    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isIOS ? F.startAdIos : F.startAdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');

          if (!adUpdateLocked) {
            startAd.value = ad;
          }
          isLoadedAd.value = true;
          adLoadAttempts[adType] = 0;
          successCallback();
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error adType ${adType}');
          startAd.value = null;
          isLoadedAd.value = false;
          adLoadAttempts[adType] = adLoadAttempts[adType]! + 1;
          errorCallback();
        },
      ),
    );
  }

  // 운동 종료 광고
  Future exerciseEndRewardedAdInit(String adType, {successCallback, errorCallback}) async {
    print(adType);
    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isIOS ? F.endAdIos : F.endAdAndroid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');

          if (!adUpdateLocked) {
            endAd.value = ad;
          }
          adLoadAttempts[adType] = 0;

          successCallback();
          // numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error adType $adType');
          endAd.value = null;
          adLoadAttempts[adType] = adLoadAttempts[adType]! + 1;
          errorCallback();
        },
      ),
    );
  }

  void showExerciseStartAd(ActivityController activityController, String adType) {
    print(adType);
    if (startAd.value == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    startAd.value!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.handleMoveExerciseActive(activityController.selectedExerciseType.value, adId: ad.adUnitId);
          startAd.value = null;
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    startAd.value!.setImmersiveMode(true);
    startAd.value!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      // DateTime now = DateTime.now();
      // HiveStore.save(key: 'exerciseStartAd', value: now);
    });
    Timer(const Duration(seconds: 1), () {
      startAd.value = null;
    });
  }

  void showExerciseEndAd(ChallengeModel challenge, ActivityController activityController) async {
    // String endAdName =
    //     await checkActivityType(selectedAd.value);

    print('끝내는운동이뭐냐${selectedAd.value}');
    if (endAd.value == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    endAd.value!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.endExercise(challenge, source: 'showEndADExerciseAlert', adId: ad.adUnitId);
          endAd.value = null;
          activityController.adLoadingTime.value = 0;
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    endAd.value!.setImmersiveMode(true);
    endAd.value!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      // DateTime now = DateTime.now();
      // HiveStore.save(key: 'exerciseEndAd', value: now);
    });
    Timer(const Duration(seconds: 1), () {
      endAd.value = null;
    });
  }
}
