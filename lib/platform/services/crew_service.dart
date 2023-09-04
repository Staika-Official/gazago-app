import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/crew.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';
import 'package:gaza_go/platform/models/crew_icon_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class CrewService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<dynamic> createCrew(CrewCreateFormModel formData, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.createCrew(userId!, formData);
    if (res.statusCode == 201) {
      print('fetch success');
      successCallback(res.data['id']);
    } else {
      print('fetch failure');
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<dynamic> joinCrew(int challengeId, int crewId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.joinCrew(userId!, challengeId, crewId);
    if (res.statusCode == 201) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }

  static Future<dynamic> getCrewMarkIcons({required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.getCrewMarkIcons();
    if (res.statusCode == 200) {
      List<CrewIconModel> iconList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((icon) {
          iconList.add(CrewIconModel.fromJson(icon));
        });
      }
      successCallback(iconList);
    } else {
      print('fetch failure');
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<dynamic> changeRecruitStatus(int crewId, String recruitStatus, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.changeRecruitStatus(userId!, crewId, recruitStatus);
    if (res.statusCode == 200) {
      print('fetch success');
      successCallback();
    } else {
      print('fetch failure');
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<dynamic> getDailyBlockCount(int crewId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.getDailyBlockCount(userId!, crewId);
    if (res.statusCode == 200) {
      successCallback(res.data);
    } else {
      print('fetch failure');
      if (errorCallback != null) errorCallback();
    }
  }
}
