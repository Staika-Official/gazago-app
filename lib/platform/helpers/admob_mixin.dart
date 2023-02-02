import 'dart:io';

import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/challenge_model.dart';

mixin AdmobMixin {
  RewardedAd? rewardedStartAd;
  RewardedAd? rewardedEndAd;
  int numRewardedLoadAttempts = 0;
  String startAdid = '';
  String endAdid = '';

  void initAdId() {
    startAdid = '';
    endAdid = '';
  }

  // 운동 시작 광고
  void exerciseStartRewardedAdInit(ExerciseType exerciseType, {successCallback, errorCallback}) async {
    if (exerciseType == ExerciseType.famous) {
      print('명산광고');
      // 100대 명산 등산 시작 광고
      startAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/7717252030' : 'ca-app-pub-4234536720874912/8417209744';
    } else if (exerciseType == ExerciseType.hiking) {
      print('등산광고');
      // 등산 시작 광고
      startAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/6424351665' : 'ca-app-pub-4234536720874912/2740311422';
    } else {
      print('걷기광고');
      // 걷기 시작 광고
      startAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/4000819566' : 'ca-app-pub-4234536720874912/3722220609';
    }

    await RewardedAd.load(
        adUnitId: startAdid,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');
          rewardedStartAd = ad;
          successCallback();
          // numRewardedLoadAttempts = 0;
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          rewardedStartAd = null;
          errorCallback();
          // numRewardedLoadAttempts += 1;
          // if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
          //   exerciseStartRewardedAdInit(exerciseType);
          // }
        }));
  }

  // 운동 종료 광고
  void exerciseEndRewardedAdInit(ExerciseType exerciseType, {successCallback, errorCallback}) async {
    if (exerciseType == ExerciseType.famous) {
      print('명산광고');
      // 100대 명산 등산 시작 광고
      endAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/6348330049' : 'ca-app-pub-4234536720874912/9538719725';
    } else if (exerciseType == ExerciseType.hiking) {
      print('등산광고');
      // 등산 시작 광고
      endAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/7940064575' : 'ca-app-pub-4234536720874912/7194545846';
    } else {
      print('걷기광고');
      // 걷기 시작 광고
      endAdid = Platform.isIOS ? 'ca-app-pub-4234536720874912/9632404289' : 'ca-app-pub-4234536720874912/4811940998';
    }
    await RewardedAd.load(
        adUnitId: endAdid,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');
          rewardedEndAd = ad;
          successCallback();
          // numRewardedLoadAttempts = 0;
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          rewardedEndAd = null;
          errorCallback();
          // numRewardedLoadAttempts += 1;
          // if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
          //   exerciseEndRewardedAdInit();
          // }
        }));
  }

  void showExerciseStartAd(ActivityController activityController) {
    if (rewardedStartAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedStartAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.handleMoveExerciseActive(activityController.selectedExerciseType.value, adId: ad.adUnitId);
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    rewardedStartAd!.setImmersiveMode(true);
    rewardedStartAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedStartAd = null;
  }

  void showExerciseEndAd(ChallengeModel challenge, ActivityController activityController) {
    if (rewardedEndAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedEndAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');

        if (ad.adUnitId.isNotEmpty) {
          activityController.endExercise(challenge, source: 'showEndADExerciseAlert', adId: ad.adUnitId);
        }

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    rewardedEndAd!.setImmersiveMode(true);
    rewardedEndAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedEndAd = null;
  }
}
