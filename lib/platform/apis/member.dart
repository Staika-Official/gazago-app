import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';

class MemberApi {
  static Future<Response> initializeUserData(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).post('users/$userId/init');
  }
}
