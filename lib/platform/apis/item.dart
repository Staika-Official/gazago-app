import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/recovery_stamina_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

import '../models/repair_shoes_model.dart';

class ItemApi {
  static Future<Response> getAllMyItems(String userId, int page, String? publishType) async {
    return await Api.client(
      serviceUrl: ServiceUrl.itemService,
      showLoading: false,
    ).get('/users/$userId', queryParameters: {'size': 100, 'page': page, 'publishType': publishType});
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
    // 첫 장착 이벤트
    bool adjustFirstEquippedItemEvent = HiveStore.load(key: HiveKey.adjustFirstEquippedItemEvent.name) ?? false;
    if (!adjustFirstEquippedItemEvent) {
      Adjust.trackEvent(AdjustEvent('qwcs58'));
      HiveStore.save(key: HiveKey.adjustFirstEquippedItemEvent.name, value: true);
    }
    return await Api.client(serviceUrl: ServiceUrl.itemService).put('/users/$userId/equip/$itemId');
  }

  static Future<Response> fetchEquippedBadge(String userId, int badgeId) async {
    return await Api.client(serviceUrl: ServiceUrl.badgeService).put('/users/$userId/equip/$badgeId');
  }

  static Future<Response> getUserConsumerItemByType(userId, itemType) async {
    return await Api.client(serviceUrl: ServiceUrl.itemService).get('/users/$userId/types/$itemType');
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
    ).patch('/users/$userId/item-repairs/$itemId', data: repairInfo);
  }

  static Future<Response> fetchRecoveryStamina(String userId, RecoveryStaminaModel recoveryInfo) async {
    return await Api.client(
      serviceUrl: ServiceUrl.staminaService,
      allowCustomErrorHandler: true,
    ).patch('/users/$userId', data: recoveryInfo);
  }
}
