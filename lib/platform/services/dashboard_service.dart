import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/dashboard.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';

import '../../constants/enums.dart';
import '../stores/hive_store.dart';

class DashboardService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<List<RankerModel>> getDailyRankingList(String date, int page, int size) async {
    Response res = await DashboardApi.getDailyRankingList(date, page, size);
    List<RankerModel> rankerList = [];

    res.data.forEach((item) => rankerList.add(RankerModel.fromJson(item)));
    return rankerList;
  }

  static Future<List<UserRewardStatisticsModel>> getUserRewardStatistics(String dateFormat, String value) async {
    Response res = await DashboardApi.getUserRewardStatistics(userId!, dateFormat, value);
    List<UserRewardStatisticsModel> list = [];
    res.data.forEach((item) => list.add(UserRewardStatisticsModel.fromJson(item)));
    return list;
  }

  static Future<RankerModel?> getDailyRankingMyRank(String date) async {
    Response res = await DashboardApi.getDailyRankingMyRank(date, userId!);
    if (res.data is Map<String, dynamic>) {
      return RankerModel.fromJson(res.data);
    }
    return null;
  }
}
