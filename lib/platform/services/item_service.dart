import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/item.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ItemService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<List<InventoryItemModel>> getAllMyItems() async {
    Response res = await ItemApi.getAllMyItems(userId!);
    List<InventoryItemModel> userItems = List.empty(growable: true);
    res.data.forEach((challenge) {
      userItems.add(InventoryItemModel.fromJson(challenge));
    });
    return userItems;
  }

  static Future<RepairShoesModel> fetchRepairItemShoes(RepairShoesModel repairInfo) async {
    Response res = await ItemApi.fetchRepairItemShoes(userId!, repairInfo);
    RepairShoesModel repairItemInfo = RepairShoesModel.fromJson(res.data);
    return repairItemInfo;
  }

  static Future<InventoryBadgeModel> fetchEquippedBadge(int badgeId) async {
    Response res = await ItemApi.fetchEquippedBadge(userId!, badgeId);
    InventoryBadgeModel equippedBadge = InventoryBadgeModel.fromJson(res.data);
    return equippedBadge;
  }
}
