import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';

class UaaApi {
  static final Dio loginApi = Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false);
  static final Dio uaaApi = Api.client(serviceUrl: ServiceUrl.uaaService);

  static Future<Response> emailLogin() {
    return loginApi.post('/sign-in/email', data: {
      "username": "admin",
      "password": "admin",
      "clientId": "GAZAGO",
    });
  }

  static Future<Response> getAccountInfo() {
    return uaaApi.get('/account');
  }
}
