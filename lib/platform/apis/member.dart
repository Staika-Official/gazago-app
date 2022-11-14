import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';

class MemberApi {
  static Future<Response> initializeUserData(String userId, String? nickname, String? profileImageUrl) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).post('/users/$userId/init', data: {'nickname': nickname, 'profileImageUrl': profileImageUrl});
  }

  static Future<Response> getMemberUserInfo(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).get('/api/users/$userId?clientId=GAZAGO');
  }

  static Future<Response> fetchTermsAgree(String userId, List<TermsHistoryModel> termsHistoryList) async {
    return await Api.client(serviceUrl: ServiceUrl.memberService).post('/api/terms-histories/users/$userId', data: termsHistoryList);
  }
}
