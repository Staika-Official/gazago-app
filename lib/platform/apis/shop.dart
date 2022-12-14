import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class ShopApi {
  static Future<Response> getShopItemsList(String sort, String? grades, String? categories) async {
    Map<String, dynamic> mapQuery = {
      'size': 100,
      'sort': sort,
      'grades': grades,
      'categories': categories,
    };

    mapQuery.removeWhere((key, value) => value == '');

    return await Api.client(
      serviceUrl: ServiceUrl.shopService,
      queryParams: mapQuery,
    ).get('/items');
  }

  static Future<Response> getShopItemDetails(int id) async {
    return await Api.client(
      serviceUrl: ServiceUrl.shopService,
    ).get('/items/$id');
  }

  static Future<Response> fetchPurchaseShopItem(String userId, int itemId) async {
    return await Api.client(
      serviceUrl: ServiceUrl.shopService,
    ).post('/items/$itemId/users/$userId/buy');
  }
}
