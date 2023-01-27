import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin AdmobMixin {
  RewardedAd? rewardedTrakingStartAd;
  int numRewardedLoadAttempts = 0;

  void rewardedTrakingStartAdInit({successCallback, errorCallback}) async {
    await RewardedAd.load(
        adUnitId: 'ca-app-pub-4234536720874912/7346094248',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          print('RewardedAd loaded');
          rewardedTrakingStartAd = ad;
          numRewardedLoadAttempts = 0;
          successCallback();
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          rewardedTrakingStartAd = null;
          numRewardedLoadAttempts += 1;
          errorCallback();
          if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
            rewardedTrakingStartAdInit();
          }
        }));
  }

  void showRewardedTrakingStartAd(ActivityController activityController) {
    if (rewardedTrakingStartAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedTrakingStartAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        if (ad.adUnitId.isNotEmpty) {
          activityController.moveToChallengeSelection();
        }
        ad.dispose();
        // rewardedTrakingStartAdInit();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // rewardedTrakingStartAdInit();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    rewardedTrakingStartAd!.setImmersiveMode(true);
    rewardedTrakingStartAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedTrakingStartAd = null;
  }
}
