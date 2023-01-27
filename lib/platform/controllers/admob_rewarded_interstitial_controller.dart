import 'dart:async';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdmobRewardedInterstitialController extends GetxController {
  RewardedInterstitialAd? rewardedInterstitialAd;
  int numRewardedInterstitialLoadAttempts = 0;
  final RxInt loadingTime = RxInt(5);
  final RxBool isViewed = RxBool(false);
  Timer? loadingTimer;

  @override
  void onInit() async {
    rewardedInterstitialAdInit();

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();

    rewardedInterstitialAd?.dispose();
  }

  void rewardedInterstitialAdInit() async {
    await RewardedInterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5354046379',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedInterstitialAd = ad;
            numRewardedInterstitialLoadAttempts = 0;
            if (!isViewed.value) {
              openRewardAdPopup();
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            rewardedInterstitialAd = null;
            numRewardedInterstitialLoadAttempts += 1;
            if (numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              rewardedInterstitialAdInit();
            }
          },
        ));
  }

  void showRewardedInterstitialAd() {
    Get.back();
    if (rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    rewardedInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdShowedFullScreenContent.');
        isViewed.value = true;
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        rewardedInterstitialAdInit();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        rewardedInterstitialAdInit();
      },
      onAdImpression: (RewardedInterstitialAd ad) => print('$ad impression occurred.'),
    );

    rewardedInterstitialAd!.setImmersiveMode(true);
    rewardedInterstitialAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedInterstitialAd = null;
  }

  void handleRemainAdTimer() {
    loadingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (loadingTime.value == 0) {
          timer.cancel();
          loadingTimer = null;
        } else {
          loadingTime.value--;
        }
      },
    );
  }

  void openRewardAdPopup() {
    handleRemainAdTimer();
    // showRewardedAdAlert(this);
  }
}
