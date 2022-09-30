import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';

class UaaApi {
  static Future<Response> emailLogin() async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false).post('/sign-in/email', data: {
      "username": "admin",
      "password": "admin",
      "clientId": "GAZAGO",
    });
  }

  static Future<Response> socialLogin(SocialLoginInfoModel loginInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false).post('/sign-in/social', data: loginInfo);
  }

  static Future<Response> getAccountInfo() async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).get('/account');
  }

  static Future<Response> checkLoginStatus() async {
    return await Api.client(serviceUrl: '/services/gazago').get('/api/ping');
  }
}
