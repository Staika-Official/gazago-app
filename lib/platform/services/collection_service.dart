import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/badge.dart';
import 'package:gaza_go/platform/apis/collection.dart';
import 'package:gaza_go/platform/models/collection_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/gathering_condition_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_list_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/models/user_badges_summaries_model.dart';
import 'package:gaza_go/platform/models/user_items_summaries_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class CollectionService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getCollectionsList({required Function successCallback, Function? errorCallback}) async {
    Response res = await CollectionApi.getCollectionsList(userId!);
    if (res.statusCode == 200) {
      List<CollectionModel> collections = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => collections.add(CollectionModel.fromJson(item)));
      }
      successCallback(collections);
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : ErrorResponseDataModel());
    }
  }

  static Future<void> getUserAllItems({required Function successCallback, Function? errorCallback}) async {
    Response res = await CollectionApi.getUserAllItems(userId!);
    if (res.statusCode == 200) {
      List<UserItemsSummariesModel> items = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => items.add(UserItemsSummariesModel.fromJson(item)));
      }
      successCallback(items);
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : ErrorResponseDataModel());
    }
  }

  static Future<void> getUserAllBadges({required Function successCallback, Function? errorCallback}) async {
    Response res = await CollectionApi.getUserAllBadges(userId!);
    if (res.statusCode == 200) {
      List<UserBadgesSummariesModel> badges = [];
      if (res.data.length > 0) {
        res.data.forEach((item) => badges.add(UserBadgesSummariesModel.fromJson(item)));
      }
      successCallback(badges);
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : ErrorResponseDataModel());
    }
  }

  static Future<void> getCollectionReward(int gatheringId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CollectionApi.getCollectionReward(gatheringId, userId!);
    if (res.statusCode == 201) {
      successCallback(GatheringConditionModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : ErrorResponseDataModel());
    }
  }
}
