import 'dart:async';
import 'dart:io';

import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/benefit_item_model.dart';
import 'package:gaza_go/platform/models/daily_benefit_list_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/services/daily_benefits_service.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class DailyBenefitController extends GetxController {
  Rxn<DailyBenefitListModel> dailyBenefitList = Rxn();
  RxBool dataGetLoading = RxBool(false);
  List<RewardedAd?> dailyRewardAdList = [null, null];
  int activeAdIndex = 0;
  RxDouble get maxRewardDistance {
    if (dailyBenefitList.value != null && dailyBenefitList.value!.benefits.isNotEmpty) {
      return RxDouble(dailyBenefitList.value!.benefits.last.distance);
    }

    return RxDouble(0);
  }

  Rx<DateTime> todaysDate = Rx(DateTime.now());
  RxString get formattedDate {
    return RxString(DateFormat('yyyy. MM. dd EEEE', 'ko').format(todaysDate.value.toLocal()));
  }

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  Future<void> initController() async {
    await getDailyBenefitsList();
    await loadAd();
  }

  Future<void> refreshController() async {
    await getDailyBenefitsList();
  }

  Future<void> getDailyBenefitsList() async {
    dataGetLoading.value = true;
    await DailyBenefitsService.getDailyBenefitsList(successCallback: (DailyBenefitListModel data) {
      dailyBenefitList.value = data;
      dataGetLoading.value = false;
    });
  }

  String getAdUnitId() {
    if (F.isDev) {
      return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    }

    if (dailyRewardAdList.first != null) {
      return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    } else {
      return Platform.isIOS ? F.dailyBenefitAd2Ios : F.dailyBenefitAd2Android;
    }
  }

  Future<void> loadAd() async {
    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: getAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('ad loaded');
          if (dailyRewardAdList.first == null) {
            dailyRewardAdList.first = ad;
          } else {
            dailyRewardAdList.last = ad;
          }
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  Future<void> requestBenefit(BenefitItemModel benefitItem) async {
    if (benefitItem.adDisplayed) {
      await requestDailyBenefitAd(benefitItem);
    } else {
      await fetchDailyBenefit(benefitItem, null);
    }
  }

  Future<void> fetchDailyBenefit(BenefitItemModel benefitItem, String? adId) async {
    await DailyBenefitsService.fetchDailyBenefit(
      benefitItem.id,
      adId,
      successCallback: (BenefitItemModel updatedItem) {
        int index = dailyBenefitList.value!.benefits.indexWhere((item) => updatedItem.id == item.id);
        dailyBenefitList.value!.benefits[index] = updatedItem;
        dailyBenefitList.refresh();
      },
      errorCallback: (ErrorResponseDataModel? errorResponse) {
        if (errorResponse != null && errorResponse.errorCode == 'DAILY_BENEFIT_TIME_UP') {
          showToastPopup(errorResponse.errorMessage!);
          getDailyBenefitsList();
        }
      },
    );
  }

  Future<void> requestDailyBenefitAd(BenefitItemModel benefitItem) async {
    dailyRewardAdList[activeAdIndex]!.fullScreenContentCallback = FullScreenContentCallback(
      // Called when the ad showed the full screen content.
      onAdShowedFullScreenContent: (ad) {
        print('onAdShowedFullScreenContent');
        loadAd();
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (ad) {},
      // Called when the ad failed to show full screen content.
      onAdFailedToShowFullScreenContent: (ad, err) {
        // Dispose the ad here to free resources.
        dailyRewardAdList[activeAdIndex]!.dispose();
      },
      // Called when the ad dismissed full screen content.
      onAdDismissedFullScreenContent: (ad) async {
        // Dispose the ad here to free resources.
        await fetchDailyBenefit(benefitItem, dailyRewardAdList[activeAdIndex]!.adUnitId);
        dailyRewardAdList[activeAdIndex]!.dispose();
        dailyRewardAdList[activeAdIndex] = null;
        activeAdIndex = activeAdIndex == 0 ? 1 : 0;
      },
      // Called when a click is recorded for an ad.
      onAdClicked: (ad) {},
    );
    dailyRewardAdList[activeAdIndex]!.setImmersiveMode(true);
    try {
      dailyRewardAdList[activeAdIndex]!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      });
    } catch (e) {
      showToastPopup('광고를 시청할 수 없습니다.');
      await loadAd();
    }
  }
}
