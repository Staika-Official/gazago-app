import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/uaa.dart';
import 'package:gaza_go/platform/models/token_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';

class UaaService {
  static Future<TokenModel> emailLogin() async {
    Response res = await UaaApi.emailLogin();
    TokenModel token = TokenModel.fromJson(res.data);
    return token;
  }

  static Future<UserAccountModel> getAccountInfo() async {
    Response res = await UaaApi.getAccountInfo();
    UserAccountModel user = UserAccountModel.fromJson(res.data);
    return user;
  }
}
