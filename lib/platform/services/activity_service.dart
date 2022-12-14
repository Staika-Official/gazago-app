import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/activity.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';

class ActivityService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getChallenges({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallenges();
    if (res.statusCode == 200) {
      List<ChallengeModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(ChallengeModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengesHierarchy(Position currentLocation, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallengesHierarchy(currentLocation);
    if (res.statusCode == 200) {
      List<ChallengeHierarchyModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(ChallengeHierarchyModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallenge(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallenge(id);
    if (res.statusCode == 200) {
      successCallback(ChallengeModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getNearByChallenges(Position currentLocation, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNearByChallenges(currentLocation);
    if (res.statusCode == 200) {
      List<ChallengeModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(ChallengeModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getCurrentUserState({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getCurrentUserState(userId!);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getUserEquippedItem({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getUserEquippedItem(userId!);
    if (res.statusCode == 200) {
      successCallback(EquippedItemModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchStartUserExercises(UserExerciseModel exerciseInfo, String platform, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchStartUserExercises(userId!, exerciseInfo, platform);
    if (res.statusCode == 201) {
      successCallback(UserExerciseModel.fromJson(res.data));
    } else {
      errorCallback!(res.statusMessage);
    }
  }

  static Future<void> fetchUpdateUserExercises(UserExerciseModel exerciseInfo, String platform, {String? source, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchUpdateUserExercises(userId!, exerciseInfo, platform, source: source);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchPausedUserExercises(UserExerciseModel exerciseInfo, String platform, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchPausedUserExercises(userId!, exerciseInfo, platform);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchEndUserExercises(UserExerciseModel exerciseInfo, {String? source, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchEndUserExercises(userId!, exerciseInfo, source: source);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> fetchUserStaminaRecharge(UserStaminaRechargeModel rechargeInfo, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchUserStaminaRecharge(userId!, rechargeInfo);
    if (res.statusCode == 200) {
      successCallback(UserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }
}
