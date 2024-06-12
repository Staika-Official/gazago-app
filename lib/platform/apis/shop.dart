import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class ShopApi {
  static Future<Response> getShopItemsList(String sort, String? grades, String? categories, String? publishType) async {
    Map<String, dynamic> mapQuery = {
      'size': 100,
      'sort': sort,
      'grades': grades,
      'categories': categories,
      'publishType': publishType,
    };

    mapQuery.removeWhere((key, value) => value == '');

    return await Api.client(
      serviceUrl: ServiceUrl.shopService,
      queryParams: mapQuery,
      showLoading: false,
    ).get('/items');
  }

  static Future<Response> getShopItemDetails(int id) async {
    return await Api.client(
      serviceUrl: ServiceUrl.shopService,
    ).get('/items/$id');
  }

  static Future<Response> fetchPurchaseShopItem(String userId, int itemId, int itemCount) async {
    // 첫 구매 이벤트
    bool adjustFirstPurchasedItemEvent = HiveStore.load(key: HiveKey.adjustFirstPurchasedItemEvent.name) ?? false;
    if (!adjustFirstPurchasedItemEvent) {
      Adjust.trackEvent(AdjustEvent('ylz6id'));
      HiveStore.save(key: HiveKey.adjustFirstPurchasedItemEvent.name, value: true);
    }

    // 구매 이벤트
    Adjust.trackEvent(AdjustEvent('i71cmi'));

    return await Api.client(
      serviceUrl: ServiceUrl.shop2Service,
    ).post('/items/$itemId/users/$userId/buy', data: {"quantity": itemCount});
  }
}
