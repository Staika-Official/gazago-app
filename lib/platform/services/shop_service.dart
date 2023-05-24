import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/shop.dart';
import 'package:gaza_go/platform/models/shop_item_model.dart';
import 'package:gaza_go/platform/models/shop_item_purchase_response_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ShopService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getShopItems(String sort, String? grades, String? categories, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ShopApi.getShopItemsList(sort, grades, categories);
    if (res.statusCode == 200) {
      List<ShopItemModel> shopItems = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          shopItems.add(ShopItemModel.fromJson(challenge));
        });
      }
      successCallback(shopItems);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getShopItemDetails(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ShopApi.getShopItemDetails(id);

    if (res.statusCode == 200) {
      successCallback(ShopItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchPurchaseShopItem(int itemId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ShopApi.fetchPurchaseShopItem(userId!, itemId);

    if (res.statusCode == 200) {
      successCallback(ShopItemPurchaseResponseModel.fromJson(res.data));
    } else if (res.statusCode == 422) {
      if (errorCallback != null) errorCallback(res.statusCode, res.data.errorCode, res.data.errorMessage);
    } else {
      if (errorCallback != null) errorCallback(res.statusCode, res.data.errorCode, res.data.errorMessage);
    }
  }
}
