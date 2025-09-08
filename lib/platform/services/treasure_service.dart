import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/treasure.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/request/get_exercise_reward_request_model.dart';
import 'package:gaza_go/platform/models/request/get_treasure_request_model.dart';
import 'package:gaza_go/platform/models/request/pick_up_treasure_request_model.dart';
import 'package:gaza_go/platform/models/response/get_exercise_reward_response_model.dart';
import 'package:gaza_go/platform/models/response/get_treasure_response_model.dart';
import 'package:gaza_go/platform/models/treasure_nearby_request_model.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';

class TreasureService {
  static Future<void> getTreasureByExerciseId({
    required GetTreasureRequestModel req,
    required void Function(GetTreasureResponseModel res) successCallback,
    void Function(ErrorResponseDataModel? error)? errorCallback,
  }) async {
    Response res = await TreasureApi.getTreasureByExerciseId(
      userId: req.userId,
      userExerciseId: req.userExerciseId,
      userLat: req.userLat,
      userLng: req.userLng,
    );

    if (res.statusCode == 200) {
      final data = GetTreasureResponseModel.fromJson(res.data);
      successCallback(data);
    } else {
      errorCallback?.call(
          res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> pickUpTreasure({
    required PickUpTreasureRequestModel req,
    required void Function(TreasureModel treasure) successCallback,
    void Function(ErrorResponseDataModel? error)? errorCallback,
  }) async {
    Response res = await TreasureApi.pickUpTreasure(
      userId: req.userId,
      userExerciseId: req.userExerciseId,
      userLat: req.userLat,
      userLng: req.userLng,
      treasureId: req.treasureId,
    );

    if (res.statusCode == 200) {
      successCallback(TreasureModel.fromJson(res.data));
    } else {
      errorCallback?.call(
          res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null);
    }
  }

  static Future<void> getExerciseRewards({
    required GetExerciseRewardRequestModel req,
    required void Function(GetExerciseRewardResponseModel rewardResponse)
        successCallback,
    void Function(ErrorResponseDataModel? error)? errorCallback,
  }) async {
    Response res = await TreasureApi.getExerciseRewards(
      userId: req.userId,
      userExerciseId: req.userExerciseId,
      page: req.page,
      size: req.size,
    );

    if (res.statusCode == 200) {
      successCallback(GetExerciseRewardResponseModel.fromJson(res.data));
    } else {
      errorCallback?.call(
        res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null,
      );
    }
  }

  static Future<void> checkNearbyTreasuresNotify({
    required int userId,
    required TreasureNearbyRequestModel req,
    void Function(List<TreasureModel>)? successCallback,
    void Function()? errorCallback,
  }) async {
    try {
      Response res = await TreasureApi.checkNearbyTreasuresNotify(
        userId: userId,
        request: req,
      );

      if (res.statusCode == 200) {
        final listVisibleTreasure = List<TreasureModel>.from(
            res.data.map((e) => TreasureModel.fromJson(e)));
        successCallback?.call(listVisibleTreasure);
      } else {
        print('Nearby treasures check failed with status: ${res.statusCode}');
        errorCallback?.call();
      }
    } catch (e) {
      print('Error checking nearby treasures: $e');
      errorCallback?.call();
    }
  }
}
