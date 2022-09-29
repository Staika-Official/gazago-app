import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';

class BadgeApi {
  static Future<List<InventoryBadgeModel>> getUserBadgesList(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.badgeService).get('/users/${userId}');
    List<InventoryBadgeModel> badges = [];
    res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return badges;
  }

  static Future<List<InventoryBadgeModel>> fetchUserEquipBadge(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.badgeService).put('/users/${userId}/equip');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    // return badges;
    return res.data;
  }

  static Future<Response> fetchUserIssuanceBadge(userId) async {
    return await Api.client(serviceUrl: ServiceUrl.badgeService).post('/users/${userId}/issues/hiking');
  }

  static Future<List<InventoryBadgeModel>> fetchUserSyntheticBadge(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.badgeService).put('/users/${userId}/issues/compose');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    // return badges;
    return res.data;
  }
}
