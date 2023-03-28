import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class AdmobApi {
  static Future<Response> getAdWatchAvailableTime(String userId, String exerciseType) async {
    return await Api.client(serviceUrl: ServiceUrl.admobService).get('/watch-available/users/$userId/$exerciseType');
  }
}
