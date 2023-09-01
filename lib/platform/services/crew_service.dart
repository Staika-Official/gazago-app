import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/crew.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';
import 'package:gaza_go/platform/models/crew_icon_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class CrewService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<dynamic> createCrew(CrewCreateFormModel formData, {required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.createCrew(userId!, formData);
    if (res.statusCode == 201) {
      print('fetch success');
    } else {
      print('fetch failure');
    }
  }

  static Future<dynamic> joinCrew({required Function successCallback, Function? errorCallback}) async {
    Response res = await CrewApi.joinCrew(userId!);
    if (res.statusCode == 201) {
      print('fetch success');
    } else {
      print('fetch failure');
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
    }
  }
}
