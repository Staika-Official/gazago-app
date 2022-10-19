import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/activity.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';

class ActivityService {
  static final String? userId = HiveStore.loadString(key: HiveKey.userId.name);

  static Future<List<ChallengeModel>> getChallenges() async {
    Response res = await ActivityApi.getChallenges();
    List<ChallengeModel> challengeList = List.empty(growable: true);
    res.data.forEach((challenge) {
      challengeList.add(ChallengeModel.fromJson(challenge));
    });
    return challengeList;
  }

  static Future<List<ChallengeModel>> getNearByChallenges(Position currentLocation) async {
    Response res = await ActivityApi.getNearByChallenges(currentLocation);
    List<ChallengeModel> challengeList = List.empty(growable: true);
    if (res.statusCode == 200) {
      res.data.forEach((challenge) {
        challengeList.add(ChallengeModel.fromJson(challenge));
      });
      return challengeList;
    } else {
      return [];
    }
  }

  static Future<CurrentUserStateModel> getCurrentUserState() async {
    Response res = await ActivityApi.getCurrentUserState(userId!);
    CurrentUserStateModel userState = CurrentUserStateModel.fromJson(res.data);
    return userState;
  }

  static Future<EquippedItemModel> getUserEquippedItem() async {
    Response res = await ActivityApi.getUserEquippedItem(userId!);

    return EquippedItemModel.fromJson(res.data);
  }

  static Future<void> fetchStartUserExercises(UserExerciseModel exerciseInfo, {Function? successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchStartUserExercises(userId!, exerciseInfo);
    if (res.statusCode == 200) {
      successCallback!(UserExerciseModel.fromJson(res.data));
    } else {
      errorCallback!(res.statusCode, res.statusMessage);
    }
  }

  static Future<CurrentUserStateModel> fetchUpdateUserExercises(UserExerciseModel exerciseInfo, {Function? onError}) async {
    Response res = await ActivityApi.fetchUpdateUserExercises(userId!, exerciseInfo);
    CurrentUserStateModel userState = CurrentUserStateModel.fromJson(res.data);
    if (res.statusCode == 404) onError!();
    return userState;
  }

  static Future<CurrentUserStateModel> fetchEndUserExercises(UserExerciseModel exerciseInfo) async {
    Response res = await ActivityApi.fetchEndUserExercises(userId!, exerciseInfo);
    CurrentUserStateModel userState = CurrentUserStateModel.fromJson(res.data);
    return userState;
  }

  static Future<UserStateModel> fetchUserStaminaRecharge(UserStaminaRechargeModel rechargeInfo) async {
    Response res = await ActivityApi.fetchUserStaminaRecharge(userId!, rechargeInfo);
    UserStateModel userState = UserStateModel.fromJson(res.data);
    return userState;
  }
}
