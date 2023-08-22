import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/activity.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_detail_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/challenge_ranker_model.dart';
import 'package:gaza_go/platform/models/challenge_reward_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/models/new_challenge_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';

class ActivityService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> getCourses({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getCourses();
    if (res.statusCode == 200) {
      List<ChallengeCourseModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(ChallengeCourseModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getNewChallenges({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNewChallenges(userId!);
    if (res.statusCode == 200) {
      List<NewChallengeModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(NewChallengeModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengesHierarchy(Position currentLocation, int challengeId, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallengesHierarchy(currentLocation, challengeId);
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

  static Future<void> getChallengeCourse(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallengeCourse(userId!, id);
    if (res.statusCode == 200) {
      successCallback(ChallengeCourseModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeDetails(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNewChallenge(userId!, id);
    if (res.statusCode == 200) {
      successCallback(NewChallengeDetailModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeLeaderboard(int id, int page, int size, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNewChallengeLeaderboard(id, page, size);
    if (res.statusCode == 200) {
      List<ChallengeRankerModel> challengeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((challenge) {
          challengeList.add(ChallengeRankerModel.fromJson(challenge));
        });
      }
      successCallback(challengeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeRewardPool(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNewChallengeRewardPool(id);
    if (res.statusCode == 200) {
      successCallback(ChallengeRewardModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeLeaderboardMyRanking(int id, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNewChallengeLeaderboardMyRanking(userId!, id);
    if (res.statusCode == 200) {
      if (res.data != '') {
        successCallback(ChallengeRankerModel.fromJson(res.data));
      } else {
        successCallback(null);
      }
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getNearByCourses(Position currentLocation, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getNearByCourses(currentLocation);
    if (res.statusCode == 200) {
      if (res.data != null) {
        List<ChallengeCourseModel> challengeList = List.empty(growable: true);
        if (res.data.length > 0) {
          res.data.forEach((type) {
            challengeList.add(ChallengeCourseModel.fromJson(type));
          });
        }
        successCallback(challengeList);
      } else {
        successCallback(List.empty(growable: true));
      }
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getCurrentUserState({bool showLoading = false, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getCurrentUserState(userId!, showLoading: showLoading);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.statusCode);
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
      errorCallback!(res.data != null ? ErrorResponseDataModel.fromJson(res.data).errorMessage : res.statusMessage);
    }
  }

  static Future<void> fetchUpdateUserExercises(UserExerciseModel exerciseInfo, String platform, {String? source, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchUpdateUserExercises(userId!, exerciseInfo, platform, source: source);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> fetchPausedUserExercises(UserExerciseModel exerciseInfo, String platform, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchPausedUserExercises(userId!, exerciseInfo, platform);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> fetchEndUserExercises(UserExerciseModel exerciseInfo, {String? source, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchEndUserExercises(userId!, exerciseInfo, source: source);
    if (res.statusCode == 200) {
      successCallback(CurrentUserStateModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback(res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
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

  static Future<dynamic> fetchLocations(int exerciseId, int page, int size) async {
    Response res = await ActivityApi.fetchLocations(userId!, exerciseId, page, size);
    if (res.statusCode == 200) {
      return res.data;
    } else {
      return [];
    }
  }

  static Future<dynamic> fetchChallengeAllianceLinkRecord(int? challengeId, String linkUrl) async {
    Response res = await ActivityApi.fetchChallengeAllianceLinkRecord(userId!, challengeId, linkUrl);
    if (res.statusCode == 201) {
      print('fetch success');
    } else {
      print('fetch failure');
    }
  }

  static Future<void> getChallenges({required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallenges(userId!);
    if (res.statusCode == 200) {
      List<ChallengeModel> challengeTypeList = List.empty(growable: true);
      if (res.data.length > 0) {
        res.data.forEach((type) {
          challengeTypeList.add(ChallengeModel.fromJson(type));
        });
      }
      successCallback(challengeTypeList);
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> getChallengeDetail({required int challengeId, required double lat, required double lon, required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.getChallengeDetail(userId!, challengeId: challengeId, lat: lat, lon: lon);
    if (res.statusCode == 200) {
      successCallback(ChallengeDetailModel.fromJson(res.data));
    } else {
      if (errorCallback != null) errorCallback();
    }
  }

  static Future<void> sendParticipateInCode(int challengeId, String code, {required Function successCallback, Function? errorCallback}) async {
    Response res = await ActivityApi.fetchChallengeParticipateInCode(userId!, challengeId, code);
    if (res.statusCode == 200) {
      successCallback(true);
    } else if (res.statusCode != 500) {
      if (errorCallback != null) {
        if (res.data != null) {
          ErrorResponseDataModel errorData = ErrorResponseDataModel.fromJson(res.data);
          errorCallback(errorData.errorMessage);
        }
      }
    }
  }
}
