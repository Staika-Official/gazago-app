import 'dart:io';

import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/challenge_model.dart';

mixin AdmobMixin {
  RxMap<String, RewardedAd?> ads = RxMap({
    "startFamousAd": null,
    "startHikingAd": null,
    "startWalkingAd": null,
    "endFamousAd": null,
    "endHikingAd": null,
    "endWalkingAd": null,
  });

  int numRewardedLoadAttempts = 0;
  String startAdid = '';
  String endAdid = '';
  RxString selectedAd = RxString('');

  void initAdId() {
    startAdid = '';
    endAdid = '';
  }

  Future checkActivityType(exerciseType) async {
    switch (exerciseType) {
      case 'FAMOUS_MOUNTAIN_100':
        return 'endFamousAd';
      case 'HIKING':
        return 'endHikingAd';
      case 'WALKING':
        return 'endWalkingAd';
    }
    return null;
  }

  Future handleSelectAdType(adType) async {
    selectedAd.value = adType;
  }

  Future initStartAdmobAdId(String adType) async {
    if (adType == 'startFamousAd') {
      print('명산광고');
      // 100대 명산 등산 시작 광고
      startAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/7717252030'
          : 'ca-app-pub-4234536720874912/8417209744';
    } else if (adType == 'startHikingAd') {
      print('등산광고');
      // 등산 시작 광고
      startAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/6424351665'
          : 'ca-app-pub-4234536720874912/2740311422';
    } else {
      print('걷기광고');
      // 걷기 시작 광고
      startAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/4000819566'
          : 'ca-app-pub-4234536720874912/3722220609';
    }
  }

  Future initEndAdmobAdId(String adType) async {
    if (adType == 'endFamousAd') {
      print('명산광고');
      // 100대 명산 등산 시작 광고
      endAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/6348330049'
          : 'ca-app-pub-4234536720874912/9538719725';
    } else if (adType == 'endHikingAd') {
      print('등산광고');
      // 등산 시작 광고
      endAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/7940064575'
          : 'ca-app-pub-4234536720874912/7194545846';
    } else {
      print('걷기광고');
      // 걷기 시작 광고
      endAdid = Platform.isIOS
          ? 'ca-app-pub-4234536720874912/9632404289'
          : 'ca-app-pub-4234536720874912/4811940998';
    }
  }

  // 운동 시작 광고
  void exerciseStartRewardedAdInit(String adType,
      {successCallback, errorCallback}) async {
    await RewardedAd.load(
        adUnitId: startAdid,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');
          print(ad);
          print(adType);
          ads[adType] = ad;
          successCallback();
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          ads[adType] = null;
          errorCallback();
        }));
  }

  // 운동 종료 광고
  Future exerciseEndRewardedAdInit(String adType,
      {successCallback, errorCallback}) async {
    await RewardedAd.load(
        adUnitId: endAdid,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');

          ads[adType] = ad;
          successCallback();
          // numRewardedLoadAttempts = 0;
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          ads[adType] = null;
          errorCallback();
        }));
  }

  void showExerciseStartAd(
      ActivityController activityController, String adType) {
    if (ads[adType] == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    ads[adType]!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.handleMoveExerciseActive(
              activityController.selectedExerciseType.value,
              adId: ad.adUnitId);
          ads[adType] = null;
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    ads[adType]!.setImmersiveMode(true);
    ads[adType]!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      DateTime now = DateTime.now();
      HiveStore.save(key: adType, value: now);
    });
    ads[adType] = null;
  }

  void showExerciseEndAd(
      ChallengeModel challenge, ActivityController activityController) async {
    // String endAdName =
    //     await checkActivityType(selectedAd.value);

    print('끝내는운동이뭐냐${selectedAd.value}');
    if (ads[selectedAd.value] == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    ads[selectedAd.value]!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.endExercise(challenge,
              source: 'showEndADExerciseAlert', adId: ad.adUnitId);
          ads[selectedAd.value] = null;
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    ads[selectedAd.value]!.setImmersiveMode(true);
    ads[selectedAd.value]!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      DateTime now = DateTime.now();

      HiveStore.save(key: selectedAd.value, value: now);
    });
    ads[selectedAd.value] = null;
  }
}
