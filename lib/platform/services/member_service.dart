import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/member.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/member_user_model.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';
import 'package:gaza_go/platform/models/terms_status_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MemberService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> initializeUserData(String? email, String? nickname, String? profileImageUrl, {required Function errorCallback}) async {
    Response res = await MemberApi.initializeUserData(userId!, email, nickname, profileImageUrl);
    if (![200, 201].any((statusCode) => statusCode == res.statusCode)) {
      errorCallback();
    }
  }

  static Future<void> getMemberUserInfo({required Function successCallback, required Function errorCallback}) async {
    Response res = await MemberApi.getMemberUserInfo(userId!);
    if (res.statusCode == 200) {
      successCallback(MemberUserModel.fromJson(res.data));
    } else {
      errorCallback(res.statusMessage);
    }
  }

  static Future<void> fetchTermsAgree(List<TermsHistoryModel> termsHistoryList, {required Function successCallback, Function? errorCallback}) async {
    Response res = await MemberApi.fetchTermsAgree(userId!, termsHistoryList);
    if (res.statusCode == 201) {
      successCallback(res.data['effectedCount']);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getTermsAgreeStatus({required Function successCallback, Function? errorCallback}) async {
    Response res = await MemberApi.getTermsAgreeStatus(userId!);
    if (res.statusCode == 200) {
      List<TermsStatusModel> terms = res.data.map<TermsStatusModel>((term) => TermsStatusModel.fromJson(term)).toList();
      successCallback(terms);
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<void> reportAbuse({
    required String description,
    required String abusingType, //GPS, ADS, EXERCISE
    int? exerciseId,
    Function? successCallback,
    Function? errorCallback,
  }) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String platform = Platform.operatingSystem;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceModel;
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine ?? 'ios model unknown';
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
    }

    Response res = await MemberApi.reportAbuse(
      userId!,
      description: description,
      exerciseId: exerciseId,
      abusingType: abusingType,
      appVersion: packageInfo.version,
      deviceModel: deviceModel,
      platform: platform,
    );
    if (res.statusCode == 201) {
      if (successCallback != null) successCallback();
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
