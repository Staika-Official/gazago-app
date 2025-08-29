import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/treasure.dart';
import 'package:gaza_go/platform/models/request/get_treasure_request_model.dart';
import 'package:gaza_go/platform/models/response/get_treasure_response_model.dart';
import 'package:gaza_go/platform/models/treasure_nearby_request_model.dart';

class TreasureService {
  static Future<void> getTreasureByExerciseId({
    required GetTreasureRequestModel req,
    required void Function(GetTreasureResponseModel res) successCallback,
    void Function()? errorCallback,
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
      errorCallback?.call();
    }
  }

  static Future<void> checkNearbyTreasuresNotify({
    required int userId,
    required TreasureNearbyRequestModel req,
    void Function()? successCallback,
    void Function()? errorCallback,
  }) async {
    try {
      Response res = await TreasureApi.checkNearbyTreasuresNotify(
        userId: userId,
        request: req,
      );

      if (res.statusCode == 200) {
        print('Nearby treasures check completed successfully');
        successCallback?.call();
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
