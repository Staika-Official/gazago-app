import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';

class ItemService {
  static Future<List<InventoryItemModel>> getMyEquipmentItemsList(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }

  static Future<List<InventoryItemModel>> getAllMyItems(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}');
    List<InventoryItemModel> allItems = [];
    res.data.forEach((item) => allItems.add(InventoryItemModel.fromJson(item)));
    // List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return allItems;
  }

  static Future<List<InventoryItemModel>> getMyItemByCategory(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}/categories');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }

  static Future<Response> getUserEquippedItem(userId) async {
    return await Api.client(serviceUrl: ServiceUrl.activityService).get('/users/${userId}/equipped');
  }

  static Future<Response> fetchRepairItemShoes(userId, itemId) async {
    return await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}/repair/${itemId}');
  }
}
