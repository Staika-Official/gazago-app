import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';

class DashboardApi {
  static Future<Response> getDailyRankingList(date) async {
    return await Api.client(serviceUrl: ServiceUrl.dashboardService, queryParams: {'date.equals': date}).get('');
  }
}
