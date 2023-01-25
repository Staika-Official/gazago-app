import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobRewardedController extends GetxController {
  RewardedAd? rewardedAd;
  int numRewardedLoadAttempts = 0;

  @override
  void onInit() async {
    // 보상형 광고 (유저가 선택)
    rewardedAdInit();

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();

    rewardedAd?.dispose();
  }

  void rewardedAdInit() async {
    await RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          print('RewardedAd loaded');
          rewardedAd = ad;
          numRewardedLoadAttempts = 0;
        }, onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          rewardedAd = null;
          numRewardedLoadAttempts += 1;
          if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
            rewardedAdInit();
          }
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
}
