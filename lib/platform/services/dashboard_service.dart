import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/dashboard.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/models/today_reward_tik_model.dart';
import 'package:gaza_go/platform/models/user_monthly_reward_statistics_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class DashboardService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getDailyRankingList(String date, int page, int size, {required Function successCallback, Function? errorCallback}) async {
    Response res = await DashboardApi.getDailyRankingList(date, page, size);
    if (res.statusCode == 200) {
      List<RankerModel> rankerList = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => rankerList.add(RankerModel.fromJson(item)));
      }
      successCallback(rankerList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getUserRewardStatistics(String dateFormat, {required Function successCallback, Function? errorCallback}) async {
    Response res = await DashboardApi.getUserRewardStatistics(userId!, dateFormat);
    if (res.statusCode == 200) {
      successCallback(UserMonthlyRewardStatisticsModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getDailyRankingMyRank(String date, {required Function successCallback, Function? errorCallback}) async {
    Response res = await DashboardApi.getDailyRankingMyRank(date, userId!);
    if (res.statusCode == 200) {
      successCallback(res.data is Map<String, dynamic> ? RankerModel.fromJson(res.data) : null);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getTodayRewardTik(String date, {required Function successCallback, Function? errorCallback}) async {
    Response res = await DashboardApi.getTodayRewardTik(date);
    if (res.statusCode == 200) {
      successCallback(res.data is Map<String, dynamic> ? TodayRewardTikModel.fromJson(res.data) : null);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
