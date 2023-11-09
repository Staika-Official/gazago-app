import 'dart:async';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
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
  RxBool adIsLoading = RxBool(false);
  RxList<RewardedAd?> dailyRewardAdList = RxList.empty(growable: true);
  RxInt activeAdIndex = RxInt(0);
  String? advertisingId = '';
  bool? isLimitAdTrackingEnabled;
  int adLoadAttemptCount = 0;

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

  Rxn<DateTime> adViewTime = Rxn();

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  Future<void> initController() async {
    await initPlatformState();
    await getDailyBenefitsList();
    await loadAd();
  }

  Future<void> refreshController() async {
    await getDailyBenefitsList();
    todaysDate.value = DateTime.now();
  }

  Future<void> getDailyBenefitsList() async {
    dataGetLoading.value = true;
    await DailyBenefitsService.getDailyBenefitsList(successCallback: (DailyBenefitListModel data) {
      dailyBenefitList.value = data;
      dataGetLoading.value = false;
    });
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

  String getAdUnitId() {
    if (dailyRewardAdList.isEmpty || dailyRewardAdList.first == null) {
      return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    } else {
      return Platform.isIOS ? F.dailyBenefitAd2Ios : F.dailyBenefitAd2Android;
    }
  }

  Future<void> loadRewardedAd() async {
    Completer completer = Completer<void>();
    await RewardedAd.load(
      adUnitId: getAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('ad loaded');
          if (dailyRewardAdList.isEmpty) {
            print('index: 0');
            dailyRewardAdList.value = [null, null];
            dailyRewardAdList.first = ad;
          } else {
            int index = activeAdIndex.value == 0 ? 1 : 0;
            print('index: $index');
            dailyRewardAdList[index] = ad;
          }
          adIsLoading.value = false;
          completer.complete();
        },
        onAdFailedToLoad: (error) async {
          adLoadAttemptCount += 1;
          adIsLoading.value = false;
          print('RewardedAd failed to load: $error');
          if (adLoadAttemptCount == 2) {
            adLoadAttemptCount = 0;
            if (Get.currentRoute.contains('daily_benefits')) showToastPopup('현재 시청 가능한 광고가 없습니다.\n잠시 후 다시 시도해 주세요.');
          } else {
            await loadRewardedAd();
          }
          completer.complete();
        },
      ),
    );
    await completer.future;
  }

  Future<void> loadAd() async {
    if (!adIsLoading.value) {
      // adIsLoading.value = true;
      await loadRewardedAd();
    }
  }

  Future<void> requestBenefit(BenefitItemModel benefitItem) async {
    DateTime requestTime = DateTime.now();
    DateTime midnight = DateTime(todaysDate.value.year, todaysDate.value.month, todaysDate.value.day + 1).toLocal();

    if (requestTime.isBefore(midnight)) {
      if (benefitItem.adDisplayed) {
        await requestDailyBenefitAd(benefitItem);
      } else {
        await fetchDailyBenefit(benefitItem, formatDateUntilDay(requestTime.toString()), null);
      }
    } else {
      showToastPopup('자정이 지났습니다. 새로고침 해주세요');
    }
  }

  Future<void> fetchDailyBenefit(BenefitItemModel benefitItem, String benefitDate, String? adId) async {
    await DailyBenefitsService.fetchDailyBenefit(
      benefitItem.id,
      benefitDate,
      adId,
      successCallback: (BenefitItemModel updatedItem) async {
        int index = dailyBenefitList.value!.benefits.indexWhere((item) => updatedItem.id == item.id);
        dailyBenefitList.value!.benefits[index] = updatedItem;
        dailyBenefitList.refresh();
        Get.find<ActivityController>().getUserState();
        Get.find<WalletMasterController>().getSpendingWalletBalances();
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
    Completer completer = Completer();
    if (dailyRewardAdList.isNotEmpty && dailyRewardAdList[activeAdIndex.value] != null) {
      dailyRewardAdList[activeAdIndex.value]!.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (ad) {
          print('onAdShowedFullScreenContent');
          adViewTime.value = DateTime.now();
          loadAd();
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when the ad failed to show full screen content.
        onAdFailedToShowFullScreenContent: (ad, AdError err) {
          // Dispose the ad here to free resources.
          print('failed to show ad');
          print(err.code);
          if (err.code == 3 && Platform.isAndroid) {
            showToastPopup('잠금상태에선 광고를 시청할 수 없습니다.');
            completer.complete();
          } else {
            completer.complete();
            dailyRewardAdList[activeAdIndex.value]!.dispose();
          }
        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (ad) async {
          // Dispose the ad here to free resources.
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {},
      );
      try {
        dailyRewardAdList[activeAdIndex.value]!.setImmersiveMode(true);
        dailyRewardAdList[activeAdIndex.value]!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          await fetchDailyBenefit(benefitItem, formatDateUntilDay(adViewTime.toString()), dailyRewardAdList[activeAdIndex.value]!.adUnitId);
          dailyRewardAdList[activeAdIndex.value]!.dispose();
          dailyRewardAdList[activeAdIndex.value] = null;
          activeAdIndex.value = activeAdIndex.value == 0 ? 1 : 0;
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
          completer.complete();
        });
      } catch (e) {
        print(e);
        showToastPopup('현재 시청 가능한 광고가 없습니다.\n잠시 후 다시 시도해 주세요.');
        dailyRewardAdList[0] = null;
        dailyRewardAdList[1] = null;
        await loadAd();
        completer.complete();
      }
    } else {
      await loadAd();
      completer.complete();
    }

    return completer.future;
  }
}
