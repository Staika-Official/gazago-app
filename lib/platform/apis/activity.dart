import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';

class ActivityService {
  static Future<List<InventoryBadgeModel>> getChallenges(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.activityService).get('');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return res.data;
  }

  static Future<List<InventoryBadgeModel>> getUserState(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.activityService).get('/users/${userId}');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return res.data;
  }

  static Future<EquippedItemModel> getUserEquippedItem(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.activityService).get('/users/${userId}/equipped');

    return res.data;
  }

  static Future<List<InventoryBadgeModel>> fetchStartUserExercises(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.exerciseService).post('/users/${userId}');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return res.data;
  }

  static Future<List<InventoryBadgeModel>> fetchUpdateUserExercises(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.exerciseService).put('/users/${userId}');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return res.data;
  }

  static Future<List<InventoryBadgeModel>> fetchEndUserExercises(userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.exerciseService).put('/users/${userId}');
    // List<InventoryBadgeModel> badges = [];
    // res.data.forEach((item) => badges.add(InventoryBadgeModel.fromJson(item)));
    return res.data;
  }
}
