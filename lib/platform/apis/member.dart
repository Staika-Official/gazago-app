import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class MemberApi {
  static Future<Response> initializeUserData(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).post('/users/$userId/init');
  }
}
