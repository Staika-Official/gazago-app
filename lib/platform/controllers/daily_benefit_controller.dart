import 'dart:async';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:app_settings/app_settings.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
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
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as ph;


class DailyBenefitController extends GetxController {
  Rxn<DailyBenefitListModel> dailyBenefitList = Rxn();
  RxBool dataGetLoading = RxBool(false);
  RxBool adIsLoading = RxBool(false);
  RxList<RewardedInterstitialAd?> dailyRewardAdList = RxList.empty(growable: true);
  RxInt activeAdIndex = RxInt(0);
  String? advertisingId = '';
  bool? isLimitAdTrackingEnabled;
  int adLoadAttemptCount = 0;
  int adLoadFacebookAttemptCount = 0;
  bool isRewardedAdLoaded = false;
  Rxn<BenefitItemModel> selectedBenefitItem = Rxn();
  RxBool loadingProgress = RxBool(true);
  RxBool isCancelAds = RxBool(false);
  RxBool isAdmobPluginInitialized = RxBool(false);

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
    await initializeMetaPlugin();
    await initController();
    super.onInit();
  }

  void toggleLoadingState() {
    loadingProgress.value = !loadingProgress.value;

  }


  Future<void> initController() async {
    await initPlatformState();
    await getDailyBenefitsList();
    await loadAd();

  }


  Future<void> initializeMetaPlugin() async {
    FacebookAudienceNetwork.init(
      iOSAdvertiserTrackingEnabled: true,
    );
  }

  Future<void> refreshController() async {
    await getDailyBenefitsList();
    todaysDate.value = DateTime.now();
  }


  void moveAppSettings() async {
    TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
    print('status: $status');
    AppSettings.openAppSettings(type: AppSettingsType.settings);

  }

  Future<bool> requestTrackingPermission() async {
    TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    print("Tracking status: $status");
    if (status == TrackingStatus.notDetermined || status == TrackingStatus.restricted || status == TrackingStatus.denied){
      // AppSettings.openAppSettings(type: AppSettingsType.settings);
      showIOSAdPermissionAlert(this);
    }

    TrackingStatus trackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    print("Tracking status after: $trackingStatus");
    if(trackingStatus == TrackingStatus.authorized) {
      return true;
    }
    return false;
  }

  Future<void> loadRewardedVideoAd() async {
    print('페이스북 광고 로드중');


    await FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: getMetaAdPlacementId(),
      listener: (result, value) async {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED){

          adViewTime.value = DateTime.now();
            print(selectedBenefitItem.value);
          if(selectedBenefitItem.value != null){
            FacebookRewardedVideoAd.showRewardedVideoAd();
            adLoadFacebookAttemptCount = 0;
            await fetchDailyBenefit(selectedBenefitItem.value!, formatDateUntilDay(adViewTime.toString()), value["placement_id"]);
            Adjust.trackEvent(AdjustEvent('7v451z'));
          }
        }
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE){
          print('비디오 끝');
        }
        if(result == RewardedVideoAdResult.VIDEO_CLOSED){
          print('비디오 닫기');
        }
        if(result == RewardedVideoAdResult.ERROR){
          print('페이스북 result : $result');
          adLoadFacebookAttemptCount += 1;

          if (adLoadFacebookAttemptCount == 2) {
            adLoadFacebookAttemptCount = 0;
            if (Get.currentRoute.contains('daily_benefits')) showToastPopup('현재 시청 가능한 광고가 없습니다.\n잠시 후 다시 시도해 주세요.');
            await loadRewardedAd();
          }

        }
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
          /// Once a Rewarded Ad has been closed and becomes invalidated,
          /// load a fresh Ad by calling this function.
          if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
              (value == true || value["invalidated"] == true)) {
            isRewardedAdLoaded = false;

            loadRewardedVideoAd();
          }
      },
    );
  }

  void showRewardedAd() {
    if (isRewardedAdLoaded == true) {
      FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {
      print("Rewarded Ad not yet loaded!");
    }
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
    return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    // if (dailyRewardAdList.isEmpty || dailyRewardAdList.first == null) {
    //   return Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android;
    // } else {
    //   return Platform.isIOS ? F.dailyBenefitAd2Ios : F.dailyBenefitAd2Android;
    // }
  }

  String getMetaAdPlacementId() {
    return Platform.isIOS ? F.dailyBenefitMetaAdIos : F.dailyBenefitMetaAdAndroid;
  }

  Future<void> loadRewardedAd() async {
    print('광고 로드 시작');
    Completer completer = Completer<void>();
    await RewardedInterstitialAd.load(
      adUnitId: getAdUnitId(),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {

          if (dailyRewardAdList.isEmpty) {
            dailyRewardAdList.value = [null, null];
            dailyRewardAdList.first = ad;
          } else {
            int index = activeAdIndex.value == 0 ? 1 : 0;
            dailyRewardAdList[activeAdIndex.value] = ad;
          }
          if( adLoadAttemptCount > 0 && selectedBenefitItem.value != null){
            requestDailyBenefitAd(selectedBenefitItem.value!);
          }
          completer.complete();
        },
        onAdFailedToLoad: (error ) async {
          String domain = error.domain;
          int code = error.code;
          String message = error.message;
          ResponseInfo? responseInfo = error.responseInfo;
          print(error);
          adLoadAttemptCount += 1;
          print('광고 로드 실패 : $dailyRewardAdList');
          if (adLoadAttemptCount == 2) {
            adLoadAttemptCount = 0;
            if (dailyRewardAdList.isEmpty) {
              print('페이스북 광고 로드');
              await loadRewardedVideoAd();
            }
            // if (Get.currentRoute.contains('daily_benefits')) showToastPopup('현재 시청 가능한 광고가 없습니다.\n잠시 후 다시 시도해 주세요.');
          } else {
            await loadRewardedAd();
          }

          completer.complete();
        },
      ),
    );
    loadingProgress.value = false;
    await completer.future;
  }

  Future<void> loadAd() async {
    if (!adIsLoading.value) {
      await loadRewardedAd();
    }
  }

  Future<void> requestBenefit(BenefitItemModel benefitItem) async {
    DateTime requestTime = DateTime.now();
    DateTime midnight = DateTime(todaysDate.value.year, todaysDate.value.month, todaysDate.value.day + 1).toLocal();

    if (requestTime.isBefore(midnight)) {
      selectedBenefitItem.value = benefitItem;
      if(benefitItem.trackingId != null && benefitItem.trackingId != ''){
        Adjust.trackEvent(AdjustEvent(benefitItem.trackingId!));
      }
      if (benefitItem.adDisplayed) {
        if(Platform.isIOS ){
          if(await requestTrackingPermission()){
            print('권한 있음');
          } else {
            return;
          }
        }
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
        selectedBenefitItem.value = null;
        if (benefitItem.adDisplayed) {

          dailyRewardAdList[activeAdIndex.value]!.dispose();
          dailyRewardAdList[activeAdIndex.value] = null;
          activeAdIndex.value = activeAdIndex.value == 0 ? 1 : 0;
        }

      },
      errorCallback: (ErrorResponseDataModel? errorResponse) {
        if (errorResponse != null && errorResponse.errorCode == 'DAILY_BENEFIT_TIME_UP') {
          showToastPopup(errorResponse.errorMessage!);
          getDailyBenefitsList();

        }
        selectedBenefitItem.value = null;
      },
    );
  }

  Future<void> requestDailyBenefitAd(BenefitItemModel benefitItem) async {
    Completer completer = Completer();
    print(dailyRewardAdList);
    if (dailyRewardAdList.isNotEmpty && dailyRewardAdList[activeAdIndex.value] != null) {
      // showToastPopup('광고 요청 중 입니다. 잠시만 기다려주세요.');
      dailyRewardAdList[activeAdIndex.value]!.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (ad) async {
          adViewTime.value = DateTime.now();
          adLoadAttemptCount  = 0;
          await loadAd();
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {

        },
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
          print('광고닫음');
          isCancelAds.value = true;
          await loadAd();

        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {},
      );
      try {
        dailyRewardAdList[activeAdIndex.value]!.setImmersiveMode(true);
        dailyRewardAdList[activeAdIndex.value]!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          await fetchDailyBenefit(benefitItem, formatDateUntilDay(adViewTime.toString()), dailyRewardAdList[activeAdIndex.value]!.adUnitId);
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');

          completer.complete();
        });
      } catch (e) {
        print(e);

        showToastPopup('현재 시청 가능한 광고가 없습니다.\n잠시 후 다시 시도해 주세요.');
        adLoadAttemptCount += 1;
        dailyRewardAdList[0] = null;
        dailyRewardAdList[1] = null;
        await loadAd();
        completer.complete();
      }
    } else {
      print('아무고토없다');

      await loadAd();
      // await loadRewardedVideoAd();
      completer.complete();
    }
    isCancelAds.value = true;
    return completer.future;
  }

}
