import 'package:dio/dio.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class CollectionApi {
  static Future<Response> getCollectionsList(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/gatherings/users/$userId');
  }

  static Future<Response> getCollectionReward(int gatheringId, String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: true,
      allowCustomErrorHandler: true,
    ).post('/user-gatherings/users/$userId/gatherings/$gatheringId');
  }

  static Future<Response> getUserAllItems(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/user-items/users/$userId/summaries');
  }

  static Future<Response> getUserAllBadges(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/user-badges/users/$userId/summaries');
  }
}
