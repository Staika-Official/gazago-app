import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';

class ExampleService {
  static Future<List<InventoryItemModel>> getList() async {
    Response res = await Api.client(serviceUrl: '/services/gazago/api/items').get('');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }

  static Future<List<InventoryItemModel>> getMyEquipmentItemsList(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/${userId}');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }
}
