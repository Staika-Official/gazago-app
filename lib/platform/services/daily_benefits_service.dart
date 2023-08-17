import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/daily_benefits.dart';
import 'package:gaza_go/platform/models/daily_benefit_list_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class DailyBenefitsService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getDailyBenefitsList({required Function successCallback, Function? errorCallback}) async {
    Response res = await DailyBenefitApi.getDailyBenefitsList(userId!);
    if (res.statusCode == 200) {
      successCallback(DailyBenefitListModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchDailyBenefit(int benefitId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await DailyBenefitApi.fetchDailyBenefit(userId!, benefitId);
    if (res.statusCode == 200) {
      successCallback(DailyBenefitListModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
