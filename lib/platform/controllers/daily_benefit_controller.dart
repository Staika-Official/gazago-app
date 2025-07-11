import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:app_settings/app_settings.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
      showIOSAdPermissionAlert(this);
    } else if (status == TrackingStatus.authorized) {
      return true;
    }
    return false;
  }

  Future<void> getDailyBenefitsList() async {
    dataGetLoading.value = true;
    await DailyBenefitsService.getDailyBenefitsList(successCallback: (data) {
      dailyBenefitList.value = data;
      dataGetLoading.value = false;
    });
  }

  Future<void> initPlatformState() async {
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
  }

  String getAdUnitId() =>
      Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;

  String getMetaAdPlacementId() =>
      Platform.isIOS ? F.dailyBenefitMetaAdIos : F.dailyBenefitMetaAdAndroid;

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
          // if( adLoadAttemptCount > 0 && selectedBenefitItem.value != null){
          //   requestDailyBenefitAd(selectedBenefitItem.value!);
          // }
          completer.complete();
        },
        onAdFailedToLoad: (error) async {
          adIsLoading.value = false;
          await loadRewardedAd();
          completer.complete();
        },
      ),
    );

    await completer.future;
  }

  Future<void> loadAd() async {
    if (!adIsLoading.value) {
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
        if (Platform.isIOS && !await requestTrackingPermission()) return;
        // await loadRewardedVideoAd();
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
      successCallback: (updatedItem) async {
        int index = dailyBenefitList.value!.benefits
            .indexWhere((item) => updatedItem.id == item.id);
        dailyBenefitList.value!.benefits[index] = updatedItem;
        dailyBenefitList.refresh();
        Get.find<ActivityController>().getUserState();
        selectedBenefitItem.value = null;
      },
      errorCallback: (errorResponse) {
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
