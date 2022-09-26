import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/apis/client.dart';
import 'package:gaza_go/platform/models/equipped_item_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';

class ActivityApi {
  static Future<Response> getChallenges() async {
    return await Api.client(serviceUrl: '/services/gazago/api').get('/challenges');
  }

  static Future<Response> getCurrentUserState(String userId) async {
    return await Api.client(serviceUrl: ServiceUrl.activityService).get('/users/$userId');
  }

  static Future<EquippedItemModel> getUserEquippedItem(String userId) async {
    Response res = await Api.client(serviceUrl: ServiceUrl.activityService).get('/users/$userId/equipped');

    return res.data;
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
}
