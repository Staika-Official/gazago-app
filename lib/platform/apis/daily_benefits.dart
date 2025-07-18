import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class DailyBenefitApi {
  static Future<Response> getDailyBenefitsList(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.dailyBenefitsService).get('/users/$userId');
  }

  static Future<Response> fetchDailyBenefit(String userId, int benefitId, String benefitDate, String? adId) async {
    return await Api.client(serviceUrl: ServiceUrl.dailyBenefitsService).post('/users/$userId/receive/$benefitId', data: {
      "benefitId": benefitId,
      "benefitDate": benefitDate,
      "adId": adId,
    });
  }
}
