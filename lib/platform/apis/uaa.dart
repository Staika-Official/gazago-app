import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class UaaApi {
  static Future<Response> emailLogin() async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false).post('/sign-in/email', data: {
      "username": "app-stage",
      "password": "fadfRt4#00",
      "clientId": "GAZAGO",
    });
  }

  static Future<Response> fetchLogout() async {
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    return await Api.client(serviceUrl: ServiceUrl.uaaService).delete('/sign-out', data: {
      "deviceId": deviceId,
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

  static Future<Response> modifyAccountInfo(String userId, String? nickname, String? profileImageUrl) async {
    return await Api.client(
      serviceUrl: ServiceUrl.uaaService,
      isPatch: true,
    ).patch('/users/$userId', data: {'id': userId, 'nickname': nickname, 'profileImageUrl': profileImageUrl});
  }

  static Future<Response> fetchUploadImage(String userId, FormData imageFile) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService, isFile: true).post('/users/$userId/upload-profile-image', data: imageFile);
  }

  static Future<Response> fetchWithdrawMember() async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).put('/account/termination', data: {
      "reason": "APP_GAZAGO_WITHDRAW",
      "clientId": "GAZAGO",
    });
  }

  static Future<Response> fetchWithdrawCancel() async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).put('/account/activation?clientId=GAZAGO');
  }

  static Future<Response> pingConnection(int seconds) async {
    return await Api.client(serviceUrl: '/services/gazago/api').get('/ping/wait/$seconds');
  }

  static Future<Response> verifyLabPassword(String password) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).post('/lab/verify', data: {
      'password': password,
    });
  }

  static Future<Response> requestLabSignIn(String email, String password) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService, needsToken: false).post('/lab/sign-in', data: {
      "clientId": "GAZAGO",
      "username": email,
      "password": password,
    });
  }
}
