import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';

class BadgeService {
  static Future<List<InventoryBadgeModel>> getUserBadgesList(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.badgeService).get('/users/${userId}');
    List<InventoryBadgeModel> badges = [];
    res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return badges;
  }
}
