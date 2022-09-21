import 'package:dio/src/response.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';

class BadgeService {
  static Future<List<InventoryBadgeModel>> getUserBadgesList(userId) async {
    Response res = await Api.client.get('/services/gazago/api/user-badges/users/${userId}');
    List<InventoryBadgeModel> badges = [];
    res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return badges;
  }
}
