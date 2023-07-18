import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';

import '../models/repair_shoes_model.dart';

class ItemApi {
  static Future<List<InventoryItemModel>> getMyEquipmentItemsList(userId) async {
    Response res = await Api.client(
      serviceUrl: ServiceUrl.itemService,
      showLoading: false,
    ).get('/users/$userId');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }

  static Future<Response> getAllMyItems(String userId, int page) async {
    return await Api.client(
      serviceUrl: ServiceUrl.itemService,
      showLoading: false,
    ).get('/users/$userId', queryParameters: {'size': 100, 'page': page});
  }

  static Future<Response> getMyItemsByCategory(String userId, String itemCategory, int page) async {
    return await Api.client(
      serviceUrl: ServiceUrl.itemService,
      showLoading: false,
    ).get('/users/$userId/categories/$itemCategory', queryParameters: {'size': 100, 'page': page});
  }

  static Future<Response> getItemDetailInfo(String userId, int itemId) async {
    return await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/$userId/$itemId');
  }

  static Future<Response> getUserEquippedItem(userId) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).get('/users/$userId/equipped');
  }

  static Future<Response> fetchEquippedItem(String userId, int itemId) async {
    return await Api.client(serviceUrl: ServiceUrl.itemService).put('/users/$userId/equip/$itemId');
  }

  static Future<Response> fetchEquippedBadge(String userId, int badgeId) async {
    return await Api.client(serviceUrl: ServiceUrl.badgeService).put('/users/$userId/equip/$badgeId');
  }

  // static Future<Response> fetchRepairItemShoes(String userId, RepairShoesModel repairInfo) async {
  //   return await Api.client(
  //     serviceUrl: ServiceUrl.itemService,
  //     allowCustomErrorHandler: true,
  //   ).patch('/users/$userId/repair/${repairInfo.id}', data: repairInfo);
  // }

  static Future<Response> fetchRepairItemShoes(String userId, int itemId, RepairShoesModel repairInfo) async {
    return await Api.client(
      serviceUrl: ServiceUrl.itemService,
      allowCustomErrorHandler: true,
    ).patch('/user/$userId/item-repair/$itemId', data: repairInfo);
  }
}
