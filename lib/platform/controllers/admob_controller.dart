import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobController extends GetxController {
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? rewardedInterstitialAd;

  @override
  void onInit() async {
    // 보상형 광고 (유저가 선택)
    rewardedAdInit();
    rewardedInterstitialAdInit();
    // 보상형 전면 광고 (유저가 선택 하지 않고 노출)

    super.onInit();
  }

  void rewardedAdInit() async {
    await RewardedAd.load(
        // adUnitId: RewardedAd.testAdUnitId,
        // 보상형 전면 광고 ca-app-pub-3940256099942544/5354046379
        // 동영상 전면 광고 ca-app-pub-3940256099942544/8691691433
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        }));
  }

  void showRewardedAd() {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        rewardedAdInit();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        rewardedAdInit();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedAd = null;
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
            showRewardedInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  void showRewardedInterstitialAd() {
    if (rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) => print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedInterstitialAd ad) => print('$ad impression occurred.'),
    );

    rewardedInterstitialAd!.setImmersiveMode(true);
    rewardedInterstitialAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedInterstitialAd = null;
  }
}
