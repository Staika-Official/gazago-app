import 'dart:ui';

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

  static Future<InventoryBadgeModel> fetchUserIssuanceBadge(int exerciseId, VoidCallback successCallback, VoidCallback errorCallback) async {
    Response res = await BadgeApi.fetchUserIssuanceBadge(userId!, exerciseId);
    if (res.statusCode == 200) {
      successCallback();
    } else {
      errorCallback();
    }
    return InventoryBadgeModel.fromJson(res.data);
  }

  static Future<InventoryBadgeModel> fetchUserSyntheticBadge(composeData) async {
    Response res = await BadgeApi.fetchUserSyntheticBadge(userId!, composeData);
    return InventoryBadgeModel.fromJson(res.data);
  }
}
