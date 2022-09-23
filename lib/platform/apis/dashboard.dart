import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';

class DashboardService {
  static Future<List<InventoryItemModel>> getDailyRankingList(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.dashboardService).get('');
    // List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return res.data;
  }
}
