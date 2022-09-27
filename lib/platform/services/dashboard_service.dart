import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/dashboard.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';

class DashboardService {
  static Future<List<RankerModel>> getDailyRankingList(String date) async {
    Response res = await DashboardApi.getDailyRankingList(date);
    List<RankerModel> rankerList = [];

    res.data.forEach((item) => rankerList.add(RankerModel.fromJson(item)));
    return rankerList;
  }
}
