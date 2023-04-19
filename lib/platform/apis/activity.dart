import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:geolocator/geolocator.dart';

class ActivityApi {
  static Future<Response> getChallenges() async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenges?size=9999&page=0');
  }

  static Future<Response> getChallengesHierarchy(Position currentLocation) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenges/hierarchy/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}',
    );
  }

  static Future<Response> getChallenge(int id) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/challenges/$id');
  }

  // static Future<Response> getNearByChallenges(LocationData currentLocation) async {
  static Future<Response> getNearByChallenges(Position currentLocation) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get(
      '/challenges/geolocation/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}',
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
    return await Api.client(serviceUrl: ServiceUrl.staminaService).post('/users/$userId', data: rechargeInfo);
  }

  static Future<Response> fetchLocations(String userId, int exerciseId, int page, int size) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).get('/users/$userId/locations/$exerciseId?page=$page&size=$size');
  }
}
