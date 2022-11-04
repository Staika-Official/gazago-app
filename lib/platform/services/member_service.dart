import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/member.dart';
import 'package:gaza_go/platform/models/terms_history_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class MemberService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> initializeUserData(String? nickname, String? profileImageUrl) async {
    await MemberApi.initializeUserData(userId!, nickname, profileImageUrl);
  }

  static Future<void> fetchTermsAgree(TermsHistoryModel termsHistoryList, {required Function successCallback, Function? errorCallback}) async {
    Response res = await MemberApi.fetchTermsAgree(userId!, termsHistoryList);
    if (res.statusCode == 201) {
      successCallback(res.data.effectedCount);
    } else {
      errorCallback!();
    }
  }
}
