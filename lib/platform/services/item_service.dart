import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/item.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ItemService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getAllMyItems(int page, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.getAllMyItems(userId!, page);
    if (res.statusCode == 200) {
      int totalItemCount = int.parse(res.headers.value('x-total-count')!);
      List<InventoryItemModel> userItems = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          userItems.add(InventoryItemModel.fromJson(challenge));
        });
      }
      successCallback(userItems, totalItemCount);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getMyItemsByCategory(String category, int page, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.getMyItemsByCategory(userId!, category, page);
    if (res.statusCode == 200) {
      List<InventoryItemModel> userItemsByCategory = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          userItemsByCategory.add(InventoryItemModel.fromJson(challenge));
        });
      }
      successCallback(userItemsByCategory);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getItemDetailInfo(int itemId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.getItemDetailInfo(userId!, itemId);
    if (res.statusCode == 200) {
      successCallback(InventoryItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchRepairItemShoes(RepairShoesModel repairInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchRepairItemShoes(userId!, repairInfo);
    if (res.statusCode == 200) {
      successCallback(InventoryItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchEquippedItem(int itemId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchEquippedItem(userId!, itemId);
    if (res.statusCode == 200) {
      successCallback(InventoryItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchEquippedBadge(int badgeId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchEquippedBadge(userId!, badgeId);
    if (res.statusCode == 200) {
      successCallback(InventoryBadgeModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
