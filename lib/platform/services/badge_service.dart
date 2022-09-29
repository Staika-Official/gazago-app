import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/badge.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class BadgeService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<List<InventoryBadgeModel>> getUserBadgesList() async {
    Response res = await BadgeApi.getUserBadgesList(userId!);
    List<InventoryBadgeModel> badges = [];
    res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return badges;
  }

  static Future<List<InventoryBadgeModel>> fetchUserEquipBadge() async {
    Response res = await BadgeApi.fetchUserEquipBadge(userId!);
    return res.data;
  }

  static Future<InventoryBadgeModel> fetchUserIssuanceBadge(int exerciseId) async {
    Response res = await BadgeApi.fetchUserIssuanceBadge(userId!, exerciseId);
    return InventoryBadgeModel.fromJson(res.data);
  }

  static Future<List<InventoryBadgeModel>> fetchUserSyntheticBadge() async {
    Response res = await BadgeApi.fetchUserSyntheticBadge(userId!);
    return res.data;
  }
}
