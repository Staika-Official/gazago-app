import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

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

  static pickUpTreasure({
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
}
