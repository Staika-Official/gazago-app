import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/challenge_join_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/platform/models/location_model.dart';

class ActivityApi {
  static Future<Response> getCourses() async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-courses?size=9999&page=0');
  }

  static Future<Response> getChallengesHierarchy(LocationModel currentLocation, int challengeId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenge-courses/hierarchy/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}?challengeId=$challengeId',
    );
  }

  static Future<Response> getChallengesNearByHierarchy(LocationModel currentLocation) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenge-courses/hierarchy/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}',
    );
  }

  static Future<Response> getChallengeCourse(String userId, int id) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-courses/users/$userId/$id');
  }

  static Future<Response> getNewChallenges(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenges/users/$userId?size=9999&page=0');
  }

  static Future<Response> getNewChallenge(String userId, int id) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenges/users/$userId/$id');
  }

  static Future<Response> getNewChallengeLeaderboard(int id, int page, int size) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-leaderboards/challenges/$id?page=$page&size=$size');
  }

  static Future<Response> getNewChallengeRewardPool(int id) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-leaderboards/challenges/$id/reward-pool');
  }

  static Future<Response> getNewChallengeLeaderboardMyRanking(String userId, int id) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-leaderboards/users/$userId/challenges/$id/ranking');
  }

  // static Future<Response> getNearByChallenges(LocationData currentLocation) async {
  static Future<Response> getNearByCourses(LocationModel currentLocation) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/v2/challenge-courses/geolocation/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}',
    );
  }

  static Future<Response> getCurrentUserState(String userId, {required bool showLoading}) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService, showLoading: showLoading).get('/users/$userId');
  }

  static Future<Response> getUserEquippedItem(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).get('/users/$userId/equipped');
  }

  static Future<Response> fetchStartUserExercises(String userId, UserExerciseModel exerciseInfo, String platform) async {
    exerciseInfo.state = 'ONGOING';
    return await Api.client(
      serviceUrl: ServiceUrl.exerciseService,
      showLoading: false,
      allowCustomErrorHandler: true,
    ).post(
      '/users/$userId',
      data: exerciseInfo,
      queryParameters: {
        'platform': platform,
        'source': 'activityActive.dart',
      },
    );
  }

  static Future<Response> fetchUpdateUserExercises(String userId, UserExerciseModel exerciseInfo, String platform, {String? source}) async {
    exerciseInfo.state = 'ONGOING';
    return await Api.client(
      serviceUrl: ServiceUrl.exerciseService,
      showLoading: false,
    ).put(
      '/users/$userId',
      data: exerciseInfo,
      queryParameters: {
        'platform': platform,
        'source': source ?? 'activityActive.dart',
      },
    );
  }

  static Future<Response> fetchPausedUserExercises(String userId, UserExerciseModel exerciseInfo, String platform) async {
    exerciseInfo.state = 'PAUSED';
    return await Api.client(
      serviceUrl: ServiceUrl.exerciseService,
      showLoading: false,
    ).put(
      '/users/$userId',
      data: exerciseInfo,
      queryParameters: {
        'platform': platform,
        'source': 'activityActive.dart',
      },
    );
  }

  static Future<Response> fetchEndUserExercises(String userId, UserExerciseModel exerciseInfo, {String? source}) async {
    exerciseInfo.state = 'ENDED';
    return await Api.client(
      serviceUrl: ServiceUrl.exerciseService,
      showLoading: false,
    ).put(
      '/users/$userId',
      data: exerciseInfo,
      queryParameters: {
        'source': source,
      },
    );
  }

  static Future<Response> fetchUserStaminaRecharge(String userId, UserStaminaRechargeModel rechargeInfo) async {
    return await Api.client(
      serviceUrl: ServiceUrl.staminaService,
      allowCustomErrorHandler: true,
    ).post('/users/$userId', data: rechargeInfo);
  }

  static Future<Response> fetchLocations(String userId, int exerciseId, int page, int size) async {
    return await Api.client(
      serviceUrl: ServiceUrl.exerciseService,
      showLoading: false,
    ).get('/users/$userId/locations/$exerciseId?page=$page&size=$size');
  }

  static Future<Response> fetchChallengeAllianceLinkRecord(String userId, int? challengeId, String linkUrl) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/alliance-link-records/users/$userId', data: {
      "userId": userId,
      "challengeId": challengeId,
      "linkUrl": linkUrl,
    });
  }

  static Future<Response> getChallenges(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenges/users/$userId/main',
    );
  }

  static Future<Response> getChallengeDetail(
    String userId, {
    required int challengeId,
    required double lat,
    required double lon,
  }) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenges/users/$userId/$challengeId/lat/$lat/lon/$lon',
    );
  }

  static Future<Response> fetchChallengeParticipateInCode(String userId, int challengeId, String code) async {
    // 첫 챌린지 참여 이벤트
    bool adjustFirstJoinedChallengeEvent = HiveStore.load(key: HiveKey.adjustFirstJoinedChallengeEvent.name) ?? false;
    if (!adjustFirstJoinedChallengeEvent) {
      Adjust.trackEvent(AdjustEvent('kvq7g5'));
      HiveStore.save(key: HiveKey.adjustFirstJoinedChallengeEvent.name, value: true);
    }

    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/user-challenges/users/$userId/challenges/$challengeId/codes/$code');
  }

  static Future<Response> fetchParticipateInPayChallenge(String userId, int challengeId, int entryfee) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/user-challenges/users/$userId/challenges/$challengeId/entryFees/$entryfee');
  }

  static Future<Response> fetchJoinChallenge(String userId, int challengeId, ChallengeJoinModel params) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/user-challenges/users/$userId/challenges/$challengeId/join', data: params);
  }

  static Future<Response> getPromotionAdsList(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenge-landings/users/$userId');
  }
}
