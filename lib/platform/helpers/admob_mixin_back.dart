// import 'package:gaza_go/platform/controllers/activity_controller.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../models/challenge_course_model.dart';
//
// mixin AdmobMixin {
//   RewardedAd? rewardedStartAd;
//   RewardedAd? rewardedEndAd;
//   int numRewardedLoadAttempts = 0;
//   String selectedStartAdid = '';
//   String selectedEndAdid = '';
//   List startAdIdList = [
//     {
//       'famous': {
//         'ios': 'ca-app-pub-4234536720874912/7717252030',
//         'aos': 'ca-app-pub-4234536720874912/8417209744',
//       }
//     },
//     {
//       'hiking': {
//         'ios': 'ca-app-pub-4234536720874912/6424351665',
//         'aos': 'ca-app-pub-4234536720874912/2740311422',
//       }
//     },
//     {
//       'walking': {
//         'ios': 'ca-app-pub-4234536720874912/4000819566',
//         'aos': 'ca-app-pub-4234536720874912/3722220609',
//       }
//     }
//   ];
//   List endAdIdList = [
//     {
//       'famous': {
//         'ios': 'ca-app-pub-4234536720874912/6348330049',
//         'aos': 'ca-app-pub-4234536720874912/9538719725',
//       }
//     },
//     {
//       'hiking': {
//         'ios': 'ca-app-pub-4234536720874912/7940064575',
//         'aos': 'ca-app-pub-4234536720874912/7194545846',
//       }
//     },
//     {
//       'walking': {
//         'ios': 'ca-app-pub-4234536720874912/9632404289',
//         'aos': 'ca-app-pub-4234536720874912/4811940998',
//       }
//     }
//   ];
//
//   void initAdId() {
//     selectedStartAdid = '';
//     selectedEndAdid = '';
//   }
//
//   // 운동 시작 광고
//   void exerciseStartRewardedAdInit({successCallback, errorCallback, required String startAdId}) async {
//     String adId = startAdId;
//     await RewardedAd.load(
//         adUnitId: adId,
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
//           print('RewardedAd loaded');
//           rewardedStartAd = ad;
//           successCallback();
//           // numRewardedLoadAttempts = 0;
//         }, onAdFailedToLoad: (error) {
//           print('RewardedAd failed to load: $error');
//           rewardedStartAd = null;
//           errorCallback();
//           // numRewardedLoadAttempts += 1;
//           // if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
//           //   exerciseStartRewardedAdInit(exerciseType);
//           // }
//         }));
//   }
//
//   // 운동 종료 광고
//   Future exerciseEndRewardedAdInit({successCallback, errorCallback, required String endAdId}) async {
//     String adId = endAdId;
//     await RewardedAd.load(
//         adUnitId: adId,
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
//           print('RewardedAd loaded');
//           rewardedEndAd = ad;
//           successCallback();
//           // numRewardedLoadAttempts = 0;
//         }, onAdFailedToLoad: (error) {
//           print('RewardedAd failed to load: $error');
//           rewardedEndAd = null;
//           errorCallback();
//           // numRewardedLoadAttempts += 1;
//           // if (numRewardedLoadAttempts < numRewardedLoadAttempts) {
//           //   exerciseEndRewardedAdInit();
//           // }
//         }));
//   }
//
//   void showExerciseStartAd(ActivityController activityController) {
//     if (rewardedStartAd == null) {
//       print('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     rewardedStartAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//
//         if (ad.adUnitId.isNotEmpty) {
//           activityController.handleMoveExerciseActive(activityController.selectedExerciseType.value, adId: ad.adUnitId);
//         }
//
//         ad.dispose();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//       },
//       onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
//     );
//
//     rewardedStartAd!.setImmersiveMode(true);
//     rewardedStartAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     rewardedStartAd = null;
//   }
//
//   void showExerciseEndAd(ChallengeCourseModel challenge, ActivityController activityController) {
//     if (rewardedEndAd == null) {
//       print('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     rewardedEndAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//
//         if (ad.adUnitId.isNotEmpty) {
//           activityController.endExercise(source: 'showEndADExerciseAlert', adId: ad.adUnitId);
//         }
//
//         ad.dispose();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//       },
//       onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
//     );
//
//     rewardedEndAd!.setImmersiveMode(true);
//     rewardedEndAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     rewardedEndAd = null;
//   }
// }
