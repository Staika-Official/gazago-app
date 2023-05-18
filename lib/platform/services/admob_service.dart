import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/admob.dart';
import 'package:gaza_go/platform/models/ad_watch_available_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class AdmobService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getAdWatchAvailableTime(String exerciseType, {required Function callback}) async {
    Response res = await AdmobApi.getAdWatchAvailableTime(userId!, exerciseType);
    if (res.statusCode == 200) {
      callback(AdWatchAvailableModel.fromJson(res.data));
    } else {
      callback(AdWatchAvailableModel(watchAvailable: false, latestWatchTime: null));
    }
  }
}
