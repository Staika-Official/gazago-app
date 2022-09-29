import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/uaa.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';

class UaaService {
  static Future<AccessTokenModel> emailLogin() async {
    Response res = await UaaApi.emailLogin();
    AccessTokenModel token = AccessTokenModel.fromJson(res.data);
    return token;
  }

  static Future<UserAccountModel> getAccountInfo() async {
    Response res = await UaaApi.getAccountInfo();
    UserAccountModel user = UserAccountModel.fromJson(res.data);
    return user;
  }

  static Future<int> checkLoginStatus() async {
    Response res = await UaaApi.checkLoginStatus();
    return res.statusCode!;
  }
}
