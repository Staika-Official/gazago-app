import 'package:dio/dio.dart';
import 'package:gaza_go/constants/base_urls.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';

class TreasureApi {
  static Future<Response> getTreasureByExerciseId({
    required num userExerciseId,
    required num userLat,
    required num userLng,
  }) async {
    return await Api.client(
      serviceUrl: ServiceUrl.treasureService,
      showLoading: false,
    ).get('/?userExerciseId=$userExerciseId&userLat=$userLat&userLng=$userLng');
  }
}
