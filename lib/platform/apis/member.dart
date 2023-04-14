import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';

class MemberApi {
  static Future<Response> initializeUserData(String userId, String? email, String? nickname, String? profileImageUrl) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).post('/users/$userId/init', data: {'email': email, 'nickname': nickname, 'profileImageUrl': profileImageUrl});
  }

  static Future<Response> getMemberUserInfo(String userId, String clientId) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).get('/api/users/$userId?clientId=$clientId');
  }

  static Future<Response> fetchTermsAgree(String userId, List<TermsHistoryModel> termsHistoryList) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).post('/api/terms-histories/users/$userId', data: termsHistoryList);
  }

  static Future<Response> getTermsAgreeStatus(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).get(
      '/api/terms-histories/users/$userId/GAZAGO',
    );
  }

  static Future<Response> reportAbuse(
    String userId, {
    int? exerciseId,
    required String abusingType,
    required String description,
    required String appVersion,
    required String deviceModel,
    required String platform,
  }) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).post(
      '/api/abusings',
      data: {
        "clientId": "GAZAGO",
        "userId": userId,
        "exerciseId": exerciseId,
        "abusingType": abusingType,
        "deviceModel": deviceModel,
        "platform": platform,
        "appVersion": appVersion,
        "description": description,
      },
    );
  }
}
