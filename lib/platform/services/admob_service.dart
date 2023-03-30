import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/admob.dart';
import 'package:gaza_go/platform/models/ad_watch_available_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class AdmobService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<AdWatchAvailableModel> getAdWatchAvailableTime(String exerciseType) async {
    Response res = await AdmobApi.getAdWatchAvailableTime(userId!, exerciseType);
    return AdWatchAvailableModel.fromJson(res.data);
  }
}
