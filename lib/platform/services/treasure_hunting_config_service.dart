import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/treasure.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/treasure_hunting_config_model.dart';

class TreasureHuntingConfigService {
  /// Get treasure hunting button content configuration
  static Future<void> getTreasureHuntingButtonContent({
    required void Function(TreasureHuntingConfigModel config) successCallback,
    void Function(ErrorResponseDataModel? error)? errorCallback,
  }) async {
    try {
      Response res = await TreasureApi.getTreasureHuntingButtonContent();

      if (res.statusCode == 200) {
        // Parse the API response as a List<dynamic>
        final data = res.data as List<dynamic>;
        final config = TreasureHuntingConfigModel.fromJson(data);
        successCallback(config);
      } else {
        // Return fallback configuration on API failure
        successCallback(TreasureHuntingConfigModel.fallback());
        errorCallback?.call(
          res.data != null ? ErrorResponseDataModel.fromJson(res.data) : null,
        );
      }
    } catch (e) {
      // Return fallback configuration on error
      successCallback(TreasureHuntingConfigModel.fallback());
      errorCallback?.call(null);
    }
  }

  /// Get treasure hunting button content configuration with retry logic
  static Future<void> getTreasureHuntingButtonContentWithRetry({
    required void Function(TreasureHuntingConfigModel config) successCallback,
    void Function(ErrorResponseDataModel? error)? errorCallback,
    int maxRetries = 2,
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        await getTreasureHuntingButtonContent(
          successCallback: successCallback,
          errorCallback: (error) {
            if (attempt == maxRetries - 1) {
              // Final attempt failed
              errorCallback?.call(error);
            }
          },
        );
        return; // Success, exit retry loop
      } catch (e) {
        attempt++;
        if (attempt == maxRetries) {
          errorCallback?.call(null);
        } else {
          await Future.delayed(Duration(seconds: attempt)); // Progressive delay
        }
      }
    }
  }
}
