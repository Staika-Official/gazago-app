import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/badge.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class BadgeService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getUserBadgesList({required Function successCallback, Function? errorCallback}) async {
    Response res = await BadgeApi.getUserBadgesList(userId!);
    if (res.statusCode == 200) {
      List<InventoryBadgeListModel> badges = [];
      res.data.forEach((item) => badges.add(InventoryBadgeListModel.fromJson(item)));
      successCallback(badges);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchUserEquipBadge({required Function successCallback, Function? errorCallback}) async {
    Response res = await BadgeApi.fetchUserEquipBadge(userId!);
    if (res.statusCode == 200) {
      successCallback(res.data);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchUserIssuanceBadge(int exerciseId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BadgeApi.fetchUserIssuanceBadge(userId!, exerciseId);
    if (res.statusCode == 200) {
      successCallback(InventoryBadgeModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchUserSyntheticBadge(composeData, {required Function successCallback, Function? errorCallback}) async {
    Response res = await BadgeApi.fetchUserSyntheticBadge(userId!, composeData);
    if (res.statusCode == 200) {
      successCallback(InventoryBadgeModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
