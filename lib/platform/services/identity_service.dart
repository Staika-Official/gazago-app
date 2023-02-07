import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/identity.dart';
import 'package:gaza_go/platform/models/verification_user_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class IdentityService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> sendIdentityCode(VerificationUserModel verificationUserModel, {required Function successCallback, Function? errorCallback}) async {
    Response res = await IdentityApi.sendIdentityCode(userId!, verificationUserModel);
    if (res.statusCode == 200) {
      successCallback(res.data['requestId']);
    } else {
      if (errorCallback != null) errorCallback(res);
    }
  }

  static Future<void> verifyIdentityCode(verifyData, {required Function successCallback, Function? errorCallback}) async {
    Response res = await IdentityApi.verifyIdentityCode(userId!, verifyData);
    if (res.statusCode == 200) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(res);
    }
  }
}
