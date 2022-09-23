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

  static Future<List<InventoryItemModel>> getMyItemByCategory(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}/categories');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }
}
