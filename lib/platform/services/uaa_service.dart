import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/uaa.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/social_login_info_model.dart';
import 'package:gaza_go/platform/models/upload_profile_image_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class UaaService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<AccessTokenModel> emailLogin() async {
    Response res = await UaaApi.emailLogin();
    AccessTokenModel token = AccessTokenModel.fromJson(res.data);
    return token;
  }

  static Future<void> fetchLogout({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchLogout();
    if (res.statusCode! == 204) {
      successCallback();
    } else if (res.statusCode != null) {
      errorCallback!(res.data);
    }
  }

  static Future<void> socialLogin(SocialLoginInfoModel loginInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.socialLogin(loginInfo);
    if ([200, 201].any((statusCode) => statusCode == res.statusCode)) {
      successCallback(AccessTokenModel.fromJson(res.data), res.statusCode);
    } else if (res.statusCode != null) {
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
    if (res.statusCode != null && res.statusCode! == 200) {
      successCallback();
    } else if (res.statusCode != null) {
      errorCallback!(res.data);
    }
  }

  static Future<UserAccountModel> modifyAccountInfo(String? nickname, String? profileImageUrl) async {
    Response res = await UaaApi.modifyAccountInfo(userId!, nickname, profileImageUrl);
    UserAccountModel user = UserAccountModel.fromJson(res.data);
    return user;
  }

  static Future<UploadProfileImageModel?> fetchUploadImage(FormData formData) async {
    Response res = await UaaApi.fetchUploadImage(userId!, formData);
    inspect(res);
    UploadProfileImageModel imageRes = UploadProfileImageModel.fromJson(res.data);
    return imageRes;
  }

  static Future<void> fetchWithdrawMember({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchWithdrawMember();
    if (res.statusCode! == 204) {
      successCallback();
    } else if (res.statusCode != null) {
      errorCallback!(res.data);
    }
  }

  static Future<void> fetchWithdrawCancel({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchWithdrawCancel();
    if (res.statusCode! == 204) {
      successCallback();
    } else if (res.statusCode != null) {
      errorCallback!(res.data);
    }
  }
}
