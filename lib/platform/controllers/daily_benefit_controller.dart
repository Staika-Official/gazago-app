import 'dart:async';
import 'dart:io';

import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/models/daily_benefit_list_model.dart';
import 'package:gaza_go/platform/services/daily_benefits_service.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DailyBenefitController extends GetxController {
  Rxn<DailyBenefitListModel> dailyBenefitList = Rxn();
  RxBool dataGetLoading = RxBool(false);
  RxDouble get maxRewardDistance {
    if (dailyBenefitList.value != null && dailyBenefitList.value!.benefits.length > 0) {
      return RxDouble(dailyBenefitList.value!.benefits.last.distance);
    }

    return RxDouble(0);
  }

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  Future<void> initController() async {
    await getDailyBenefitsList();
    await loadInitialAd();
  }

  Future<void> refreshController() async {
    await getDailyBenefitsList();
  }

  Future<void> getDailyBenefitsList() async {
    dataGetLoading.value = true;
    await DailyBenefitsService.getDailyBenefitsList(successCallback: (DailyBenefitListModel data) {
      dailyBenefitList.value = data;
      dailyBenefitList.value?.benefits.forEach((element) {
        print(element.toJson());
      });
      print(dailyBenefitList.value?.benefits.length);
      dataGetLoading.value = false;
    });
  }

  Future<void> loadInitialAd() async {
    await RewardedAd.load(
      // adUnitId: Platform.isIOS ? 'ca-app-pub-3940256099942544/1712485313' : 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isIOS ? F.dailyBenefitAd1Ios : F.dailyBenefitAd1Android,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded');
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}
