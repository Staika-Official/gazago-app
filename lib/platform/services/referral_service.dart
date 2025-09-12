import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/referral.dart';
import 'package:gaza_go/platform/models/referee_model.dart';

class ReferralService {
  static Future<void> getReferees(
    String userId, {
    required Function(RefereeResponseModel) successCallback,
    Function? errorCallback,
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response res = await ReferralApi.getReferees(userId, page: page, size: size);
      if (res.statusCode == 200) {
        successCallback(RefereeResponseModel.fromJson(res.data));
      } else {
        if (errorCallback != null) errorCallback(res.data);
      }
    } catch (e) {
      if (errorCallback != null) errorCallback(e);
    }
  }
}
