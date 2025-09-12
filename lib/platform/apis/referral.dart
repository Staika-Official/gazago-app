import 'package:dio/dio.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class ReferralApi {
  // API GET /services/gazago/api/user-referral/{userId}/referees
  static Future<Response> getReferees(String userId, {int page = 0, int size = 10}) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/user-referral/$userId/referees?page=$page&size=$size');
  }
}
