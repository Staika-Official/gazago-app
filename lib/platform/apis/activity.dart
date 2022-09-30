import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:location/location.dart';

class ActivityApi {
  static Future<Response> getChallenges() async {
    return await Api.client(serviceUrl: '/services/gazago/api').get('/challenges');
  }

  static Future<Response> getNearByChallenges(LocationData currentLocation) async {
    return await Api.client(serviceUrl: '/services/gazago/api').get(
      '/challenges/geolocation/lat/${currentLocation.latitude}/lon/${currentLocation.longitude}',
    );
  }

  static Future<Response> getCurrentUserState(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).get('/users/$userId');
  }

  static Future<Response> getUserEquippedItem(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.stateService).get('/users/$userId/equipped');
  }

  static Future<Response> fetchStartUserExercises(String userId, UserExerciseModel exerciseInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).post('/users/$userId', data: exerciseInfo);
  }

  static Future<Response> fetchUpdateUserExercises(String userId, UserExerciseModel exerciseInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).put('/users/$userId', data: exerciseInfo);
  }

  static Future<Response> fetchEndUserExercises(String userId, UserExerciseModel exerciseInfo) async {
    exerciseInfo.state = 'ENDED';
    return await Api.client(serviceUrl: ServiceUrl.exerciseService).put('/users/$userId', data: exerciseInfo);
  }

  static Future<Response> fetchUserStaminaRecharge(String userId, UserStaminaRechargeModel rechargeInfo) async {
    return await Api.client(serviceUrl: ServiceUrl.staminaService).post('/users/$userId', data: rechargeInfo);
  }
}
