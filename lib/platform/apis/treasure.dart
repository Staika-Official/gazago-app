import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/treasure_nearby_request_model.dart';

class TreasureApi {
  static Future<Response> getTreasureByExerciseId({
    required num userId,
    required num userExerciseId,
    required num userLat,
    required num userLng,
  }) async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
    ).get(
        '/?userId=$userId&userExerciseId=$userExerciseId&userLat=$userLat&userLng=$userLng');
  }

  static Future<Response> checkNearbyTreasuresNotify({
    required int userId,
    required TreasureNearbyRequestModel request,
  }) async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
    ).post(
      '/$userId/check-nearby-treasures-notify',
      data: request.toJson(),
    );
  }

  static Future<Response> pickUpTreasure({
    required num userId,
    required num userExerciseId,
    required num userLat,
    required num userLng,
    required num treasureId,
  }) async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
      showToastOnError: false,
    ).post(
        '-claim?userId=$userId&userExerciseId=$userExerciseId&userLat=$userLat&userLng=$userLng&treasureId=$treasureId');
  }

  static Future<Response> getExerciseRewards({
    required num userId,
    required num userExerciseId,
    required num page,
    required num size,
  }) async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
    ).get('/$userExerciseId?userId=$userId&page=$page&size=$size');
  }

  /// Get treasure hunting button content configuration
  static Future<Response> getTreasureHuntingButtonContent() async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
    ).get('-hunting/button-content');
  }
}
