import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';

class BadgeApi {
  static final Dio badgeApi = Api.client(serviceUrl: ServiceUrl.badgeService);

  static Future<Response> getUserBadgesList(String userId) async {
    return await badgeApi.get('/users/$userId');
  }

  static Future<Response> fetchUserEquipBadge(String userId) async {
    return await badgeApi.put('/users/$userId/equip');
  }

  static Future<Response> fetchUserIssuanceBadge(String userId, int exerciseId) async {
    return await badgeApi.post('/users/$userId/issues/hiking', data: {
      'userExerciseId': exerciseId,
    });
  }

  static Future<Response> fetchUserSyntheticBadge(String userId) async {
    return await badgeApi.put('/users/$userId/issues/compose');
  }
}
