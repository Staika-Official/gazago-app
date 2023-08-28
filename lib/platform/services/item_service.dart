import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/item.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/recovery_stamina_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

import '../models/repair_shoes_model.dart';

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

  static Future<void> fetchRepairItemShoes(int itemId, RepairShoesModel repairInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchRepairItemShoes(userId!, itemId, repairInfo);
    if (res.statusCode == 200) {
      successCallback(InventoryItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> fetchRecoveryStamina(RecoveryStaminaModel recoveryInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchRecoveryStamina(userId!, recoveryInfo);
    if (res.statusCode == 200) {
      successCallback(UserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
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

  static Future<void> getUserConsumerItemByType(String itemType, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.getUserConsumerItemByType(userId!, itemType);
    if (res.statusCode == 200) {
      List<InventoryItemModel> userItemsByType = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          userItemsByType.add(InventoryItemModel.fromJson(challenge));
        });
      }
      successCallback(userItemsByType);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
