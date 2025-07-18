import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:app_settings/app_settings.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
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
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class DailyBenefitController extends GetxController {
  Rxn<DailyBenefitListModel> dailyBenefitList = Rxn();
  RxBool dataGetLoading = RxBool(false);
  RxBool adIsLoading = RxBool(false);
  RxList<RewardedInterstitialAd?> dailyRewardAdList =
      RxList.empty(growable: true);
  RxInt activeAdIndex = RxInt(0);
  String? advertisingId = '';
  bool? isLimitAdTrackingEnabled;
  int adLoadAttemptCount = 0;
  int adLoadFacebookAttemptCount = 0;
  bool isRewardedAdLoaded = false;
  Rxn<BenefitItemModel> selectedBenefitItem = Rxn();
  RxBool isCancelAds = RxBool(false);
  RxBool isAdmobPluginInitialized = RxBool(false);

  RxDouble get maxRewardDistance {
    if (dailyBenefitList.value != null &&
        dailyBenefitList.value!.benefits.isNotEmpty) {
      return RxDouble(dailyBenefitList.value!.benefits.last.distance);
    }

    return RxDouble(0);
  }

  Rx<DateTime> todaysDate = Rx(DateTime.now());
  RxString get formattedDate {
    String locale = PlatformDispatcher.instance.locale.languageCode;
    return RxString(DateFormat('yyyy. MM. dd EEEE', locale)
        .format(todaysDate.value.toLocal()));
  }

  Rxn<DateTime> adViewTime = Rxn();

  @override
  void onInit() async {
    await initializeMetaPlugin();
    await initController();
    super.onInit();
  }

  Future<void> initController() async {
    await initPlatformState();
    await getDailyBenefitsList();
    await loadAd();
  }

  Future<void> initializeMetaPlugin() async {
    // FacebookAudienceNetwork.init(
    //   iOSAdvertiserTrackingEnabled: true,
    // );
  }

  Future<void> refreshController() async {
    await getDailyBenefitsList();
    todaysDate.value = DateTime.now();
  }

  void moveAppSettings() async {
    Get.back();
    AppSettings.openAppSettings(type: AppSettingsType.settings);
  }

  Future<bool> requestTrackingPermission() async {
    TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.restricted ||
        status == TrackingStatus.denied) {
      showIOSDeniedAdPermissionAlert(this);
    } else if (status == TrackingStatus.notDetermined) {
      // 앱 개인정보보호 및 보안에서 추적을 허용하긴 했음
      showIOSAdPermissionAlert(this);
    } else if (status == TrackingStatus.authorized) {
      return true;
    }
    return false;
  }

  Future<void> loadRewardedVideoAd() async {
    // await FacebookRewardedVideoAd.loadRewardedVideoAd(
    //   placementId: getMetaAdPlacementId(),
    //   listener: (result, value) async {
    //     if (result == RewardedVideoAdResult.LOADED) {
    //       adViewTime.value = DateTime.now();
    //       if (selectedBenefitItem.value != null) {
    //         FacebookRewardedVideoAd.showRewardedVideoAd();
    //         adLoadFacebookAttemptCount = 0;
    //         await fetchDailyBenefit(
    //             selectedBenefitItem.value!,
    //             formatDateUntilDay(adViewTime.toString()),
    //             value["placement_id"]);
    //         Adjust.trackEvent(AdjustEvent('7v451z'));
    //       }
    //     }
    //     if (result == RewardedVideoAdResult.VIDEO_COMPLETE) {}
    //     if (result == RewardedVideoAdResult.VIDEO_CLOSED) {}
    //     if (result == RewardedVideoAdResult.ERROR) {
    //       adLoadFacebookAttemptCount += 1;

    //       if (adLoadFacebookAttemptCount == 2) {
    //         adLoadFacebookAttemptCount = 0;
    //         if (Get.currentRoute.contains('daily_benefits'))
    //           showToastPopup('no_ads_available'.tr());
    //         await loadRewardedAd();
    //       }
    //     }
    //     if (result == RewardedVideoAdResult.VIDEO_COMPLETE)

    //     /// Once a Rewarded Ad has been closed and becomes invalidated,
    //     /// load a fresh Ad by calling this function.
    //     if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
    //         (value == true || value["invalidated"] == true)) {
    //       isRewardedAdLoaded = false;

    //       loadRewardedVideoAd();
    //     }
    //   },
    // );
  }

  void showRewardedAd() {
    if (isRewardedAdLoaded == true) {
      // FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {}
  }

  Future<void> getDailyBenefitsList() async {
    dataGetLoading.value = true;
    await DailyBenefitsService.getDailyBenefitsList(
        successCallback: (DailyBenefitListModel data) {
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
    return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    // if (dailyRewardAdList.isEmpty || dailyRewardAdList.first == null) {
    //   return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    // } else {
    //   return Platform.isIOS ? F.dailyBenefitAd2Ios : F.dailyBenefitAd2Android;
    // }
  }

  String getMetaAdPlacementId() {
    return Platform.isIOS
        ? F.dailyBenefitMetaAdIos
        : F.dailyBenefitMetaAdAndroid;
  }

  Future<void> loadRewardedAd() async {
    Completer completer = Completer<void>();
    adIsLoading.value = true;
    await RewardedInterstitialAd.load(
      adUnitId: getAdUnitId(),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          adIsLoading.value = false;
          if (dailyRewardAdList.isEmpty) {
            dailyRewardAdList.value = [null, null];
            dailyRewardAdList.first = ad;
          } else {
            dailyRewardAdList[activeAdIndex.value] = ad;
          }
          // dailyRewardAdList[activeAdIndex.value] = null;
          print('ad_load_success_daily_reward'
              .tr(args: ['${dailyRewardAdList}']));
          print('ad_load_success_active_index'
              .tr(args: ['${activeAdIndex.value}']));
          print('ad_load_success_attempt_count'
              .tr(args: ['${adLoadAttemptCount}']));
          // if( adLoadAttemptCount > 0 && selectedBenefitItem.value != null){
          //   requestDailyBenefitAd(selectedBenefitItem.value!);
          // }
          completer.complete();
        },
        onAdFailedToLoad: (error) async {
          adIsLoading.value = false;
          adLoadAttemptCount += 1;
          if (adLoadAttemptCount == 2) {
            adLoadAttemptCount = 0;
            if (dailyRewardAdList.isEmpty) {
              await loadRewardedVideoAd();
            }
            // if (Get.currentRoute.contains('daily_benefits')) showToastPopup('no_ads_available'.tr());
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
      print('333');
      await loadRewardedAd();
    }
  }

  Future<void> requestBenefit(BenefitItemModel benefitItem) async {
    DateTime requestTime = DateTime.now();
    DateTime midnight = DateTime(todaysDate.value.year, todaysDate.value.month,
            todaysDate.value.day + 1)
        .toLocal();

    if (requestTime.isBefore(midnight)) {
      selectedBenefitItem.value = benefitItem;
      if (benefitItem.trackingId != null && benefitItem.trackingId != '') {
        Adjust.trackEvent(AdjustEvent(benefitItem.trackingId!));
      }
      if (benefitItem.adDisplayed) {
        if (Platform.isIOS) {
          if (await requestTrackingPermission()) {
          } else {
            return;
          }
        }
        await requestDailyBenefitAd(benefitItem);
      } else {
        await fetchDailyBenefit(
            benefitItem, formatDateUntilDay(requestTime.toString()), null);
      }
    } else {
      showToastPopup('midnight_passed_refresh'.tr());
    }
  }

  Future<void> fetchDailyBenefit(
      BenefitItemModel benefitItem, String benefitDate, String? adId) async {
    await DailyBenefitsService.fetchDailyBenefit(
      benefitItem.id,
      benefitDate,
      adId,
      successCallback: (BenefitItemModel updatedItem) async {
        int index = dailyBenefitList.value!.benefits
            .indexWhere((item) => updatedItem.id == item.id);
        dailyBenefitList.value!.benefits[index] = updatedItem;
        dailyBenefitList.refresh();
        Get.find<ActivityController>().getUserState();
        // Get.find<WalletMasterController>().getSpendingWalletBalances();
        selectedBenefitItem.value = null;
      },
      errorCallback: (ErrorResponseDataModel? errorResponse) {
        if (errorResponse != null) {
          showToastPopup(errorResponse.errorMessage!);
          if (errorResponse.errorCode == 'DAILY_BENEFIT_TIME_UP') {
            getDailyBenefitsList();
          }
        }
        selectedBenefitItem.value = null;
      },
    );
  }

  Future<int> findNonNullIndices(List<dynamic> arr) async {
    int indices = 0;

    for (int i = 0; i < arr.length; i++) {
      if (arr[i] != null) {
        indices = i;
      }
    }

    return indices;
  }

  Future<void> requestDailyBenefitAd(BenefitItemModel benefitItem) async {
    Completer completer = Completer();

    activeAdIndex.value = await findNonNullIndices(dailyRewardAdList);

    if (dailyRewardAdList[0] != null || dailyRewardAdList[1] != null) {
      // showToastPopup('ad_requesting'.tr());

      dailyRewardAdList[activeAdIndex.value]!.fullScreenContentCallback =
          FullScreenContentCallback(
        // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (ad) async {
          adViewTime.value = DateTime.now();

          await loadAd();
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when the ad failed to show full screen content.
        onAdFailedToShowFullScreenContent: (ad, AdError err) {
          // Dispose the ad here to free resources.

          if (err.code == 3 && Platform.isAndroid) {
            showToastPopup('ad_view_locked'.tr());
            completer.complete();
          } else {
            showToastPopup('ad_loading'.tr());
            dailyRewardAdList[activeAdIndex.value]!.dispose();
            dailyRewardAdList.value = [null, null];
            activeAdIndex.value = 0;
            loadAd();
            completer.complete();
          }
        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (ad) async {
          // Dispose the ad here to free resources.
          isCancelAds.value = true;
          // dailyRewardAdList[activeAdIndex.value]!.dispose();
          await loadAd();
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {},
      );
      try {
        dailyRewardAdList[activeAdIndex.value]!.setImmersiveMode(true);
        dailyRewardAdList[activeAdIndex.value]!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          await fetchDailyBenefit(
              benefitItem,
              formatDateUntilDay(adViewTime.toString()),
              dailyRewardAdList[activeAdIndex.value]!.adUnitId);

          dailyRewardAdList[activeAdIndex.value]!.dispose();
          dailyRewardAdList[activeAdIndex.value] = null;
          activeAdIndex.value = activeAdIndex.value == 0 ? 1 : 0;
          adLoadAttemptCount = 0;

          completer.complete();
        });
      } catch (e) {
        showToastPopup('no_ads_available'.tr());
        adLoadAttemptCount += 1;
        dailyRewardAdList[0] = null;
        dailyRewardAdList[1] = null;
        await loadAd();
        completer.complete();
      }
    } else {
      if (adIsLoading.value) {
        showToastPopup('ad_loading'.tr());
      }

      await loadAd();
      // await loadRewardedVideoAd();
      completer.complete();
    }
    isCancelAds.value = true;
    return completer.future;
  }

  void reCheckPermissionStatus() async {
    TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.authorized && Get.isBottomSheetOpen!) {
      Get.back();
    }
  }

  void onResumed() {
    reCheckPermissionStatus();
  }
}
