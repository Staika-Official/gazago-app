import 'package:dio/src/response.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';

class ExampleService {
  static Future<List<InventoryItemModel>> getList() async {
    Response res = await Api.client.get('/services/gazago/api/items');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }

  static Future<List<InventoryItemModel>> getMyEquipmentItemsList(userId) async {
    Response res = await Api.client.get('/user-items/users/${userId}');
    List<InventoryItemModel> items = res.data.map((item) => InventoryItemModel.fromJson(item));
    return items;
  }
}
