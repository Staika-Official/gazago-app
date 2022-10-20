import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/uaa.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';

class UaaService {
  static Future<AccessTokenModel> emailLogin() async {
    Response res = await UaaApi.emailLogin();
    AccessTokenModel token = AccessTokenModel.fromJson(res.data);
    return token;
  }

  static Future<void> socialLogin(SocialLoginInfoModel loginInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.socialLogin(loginInfo);
    if ([200, 201].any((statusCode) => statusCode == res.statusCode)) {
      successCallback(AccessTokenModel.fromJson(res.data), res.statusCode);
    } else {
      errorCallback!();
    }
  }

  static Future<UserAccountModel> getAccountInfo() async {
    Response res = await UaaApi.getAccountInfo();
    UserAccountModel user = UserAccountModel.fromJson(res.data);
    return user;
  }

  static Future<void> checkLoginStatus({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.checkLoginStatus();
    if (res.statusCode! == 200) {
      successCallback();
    } else {
      errorCallback!();
    }
  }
}
