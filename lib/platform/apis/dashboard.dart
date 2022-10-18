import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class DashboardApi {
  static Future<Response> getDailyRankingList(date, page, size) async {
    return await Api.client(serviceUrl: '${ServiceUrl.dashboardService}/ranking/$date', queryParams: {'size': size, 'page': page}).get('');
  }

  static Future<Response> getDailyRankingMyRank(date, userId) async {
    return await Api.client(serviceUrl: '${ServiceUrl.dashboardService}/ranking/$date/users/$userId').get('');
  }

  static getUserRewardStatistics(String userId, String dateFormat, String value) async {
    return await Api.client(serviceUrl: '${ServiceUrl.dashboardService}/users/$userId/statistics/$dateFormat/$value').get('');

  }
}
