import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class IdentityApi {
  static Future<Response> sendIdentityCode(userId, verificationUserModel) async {
    return await Api.client(serviceUrl: ServiceUrl.uaaService).post('/v2/user-identities/users/$userId/sms', data: verificationUserModel);
  }

  static Future<Response> verifyIdentityCode(userId, verifyData) async {
    return await Api.client(
      serviceUrl: ServiceUrl.uaaService,
      allowCustomErrorHandler: true,
    ).post('/v2/user-identities/users/$userId/sms/verify', data: verifyData);
  }
}
