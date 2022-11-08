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

  static Future<List<InventoryItemModel>> getAllMyItems() async {
    Response res = await ItemApi.getAllMyItems(userId!);
    List<InventoryItemModel> userItems = List.empty(growable: true);
    res.data.forEach((challenge) {
      userItems.add(InventoryItemModel.fromJson(challenge));
    });

    return userItems;
  }

  static Future<InventoryItemModel> getItemDetailInfo(int itemId) async {
    Response res = await ItemApi.getItemDetailInfo(userId!, itemId);
    InventoryItemModel itemDetailInfo = InventoryItemModel.fromJson(res.data);
    return itemDetailInfo;
  }

  static Future<void> fetchRepairItemShoes(RepairShoesModel repairInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ItemApi.fetchRepairItemShoes(userId!, repairInfo);
    if (res.statusCode == 200) {
      successCallback(InventoryItemModel.fromJson(res.data));
    } else {
      errorCallback!();
    }
  }

  static Future<InventoryItemModel> fetchEquippedItem(int itemId) async {
    Response res = await ItemApi.fetchEquippedItem(userId!, itemId);
    InventoryItemModel equippedItem = InventoryItemModel.fromJson(res.data);
    return equippedItem;
  }

  static Future<InventoryBadgeModel> fetchEquippedBadge(int badgeId) async {
    Response res = await ItemApi.fetchEquippedBadge(userId!, badgeId);
    InventoryBadgeModel equippedBadge = InventoryBadgeModel.fromJson(res.data);
    return equippedBadge;
  }
}
