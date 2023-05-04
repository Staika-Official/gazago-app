import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/uaa.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
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
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> socialLogin(SocialLoginInfoModel loginInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.socialLogin(loginInfo);
    if ([200, 201].any((statusCode) => statusCode == res.statusCode)) {
      successCallback(AccessTokenModel.fromJson(res.data), res.statusCode);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> getAccountInfo({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.getAccountInfo();
    if (res.statusCode == 200) {
      successCallback(UserAccountModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> checkLoginStatus({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.checkLoginStatus();
    if (res.statusCode == 200) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> modifyAccountInfo(String? nickname, String? profileImageUrl, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.modifyAccountInfo(userId!, nickname, profileImageUrl);
    if (res.statusCode == 200) {
      successCallback(UserAccountModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> fetchUploadImage(FormData formData, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchUploadImage(userId!, formData);
    if (res.statusCode == 201) {
      successCallback(UploadProfileImageModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchUploadImageUrl(String fileName, {required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchUploadImageUrl(fileName);
    if (res.statusCode == 200) {
      successCallback(res.data);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> uploadToS3bucket(String presignedUrl, File profileImage, String contentType) async {
    await UaaApi.uploadToS3bucket(presignedUrl, profileImage, contentType);
  }

  static Future<void> fetchWithdrawMember({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchWithdrawMember();
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> fetchWithdrawCancel({required Function successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.fetchWithdrawCancel();
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> pingConnection(int seconds, {Function? successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.pingConnection(seconds);
    if (res.statusCode == 200) {
      if (successCallback != null) successCallback(res.data);
    } else {
      if (errorCallback != null) errorCallback(res.data);
    }
  }

  static Future<void> verifyLabPassword(String password, {Function? successCallback, Function? errorCallback}) async {
    Response res = await UaaApi.verifyLabPassword(password);
    if (res.statusCode == 200) {
      if (successCallback != null) successCallback();
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> requestLabSignIn(String password, {Function? successCallback, Function? errorCallback}) async {
    String? email = HiveStore.loadString(key: HiveKey.email.name);
    Response res = await UaaApi.requestLabSignIn(email!, password);
    if (res.statusCode == 200) {
      if (successCallback != null) successCallback(AccessTokenModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
