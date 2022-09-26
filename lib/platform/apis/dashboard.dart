import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';

class DashboardService {
  static Future<List<RankerModel>> getDailyRankingList(date) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.dashboardService, queryParams: {'date.equals': date}).get('');
    List<RankerModel> rankerList = [];

    res.data.forEach((item) => rankerList.add(RankerModel.fromJson(item)));
    return rankerList;
  }
}
