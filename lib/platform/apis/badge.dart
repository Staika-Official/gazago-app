import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class BadgeApi {
  static Future<Response> getUserBadgesList(String userId) async {
    return await Api.client(
      serviceUrl: ServiceUrl.badgeService,
      showLoading: false,
    ).get('/users/$userId');
  }

  static Future<Response> fetchUserEquipBadge(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.badgeService).put('/users/$userId/equip');
  }

  static Future<Response> fetchUserIssuanceBadge(String userId, int exerciseId) async {
    return await Api.client(
      serviceUrl: ServiceUrl.badgeService,
      showLoading: false,
    ).post('/users/$userId/issues/challenge', data: {
      'userExerciseId': exerciseId,
    });
  }

  static Future<Response> fetchUserSyntheticBadge(String userId, Map composeData) async {
    return await Api.client(serviceUrl: ServiceUrl.badgeService).post('/users/$userId/issues/compose', data: composeData);
  }
}
