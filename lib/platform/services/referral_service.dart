import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/apis/referral.dart';
import 'package:gaza_go/platform/models/referee_model.dart';
import 'package:gaza_go/platform/models/referral_config_model.dart';

class ReferralService {
  static Future<void> getReferees(
    String userId, {
    required Function(RefereeResponseModel) successCallback,
    Function? errorCallback,
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response res = await ReferralApi.getReferees(userId, page: page, size: size);
      if (res.statusCode == 200) {
        successCallback(RefereeResponseModel.fromJson(res.data));
      } else {
        if (errorCallback != null) errorCallback(res.data);
      }
    } catch (e) {
      if (errorCallback != null) errorCallback(e);
    }
  }

  static Future<void> redeemReferralCode(
    String userId,
    String referralCode, {
    required Function() successCallback,
    Function(String, bool)? errorCallback, // bool isCodeNotFound
  }) async {
    try {
      Response res = await ReferralApi.redeemReferralCode(userId, referralCode);
      
      // Check if response data contains error (even if status code is 200)
      // This can happen when DioMiddleware resolves error responses
      if (_hasErrorInData(res.data)) {
        String errorMessage = _getErrorMessage(res.data);
        bool isCodeNotFound = _isCodeNotFound(res.data);
        if (errorCallback != null) errorCallback(errorMessage, isCodeNotFound);
      } else if (res.statusCode == 200) {
        successCallback();
      } else {
        // Handle other non-200 status codes
        String errorMessage = _getErrorMessage(res.data);
        bool isCodeNotFound = _isCodeNotFound(res.data);
        if (errorCallback != null) errorCallback(errorMessage, isCodeNotFound);
      }
    } catch (e) {
      String errorMessage = 'referral_redeem_failed'.tr();
      bool isCodeNotFound = false;
      
      // Handle DioException for specific error codes
      if (e is DioException && e.response != null) {
        errorMessage = _getErrorMessage(e.response!.data);
        isCodeNotFound = _isCodeNotFound(e.response!.data);
      }
      
      if (errorCallback != null) errorCallback(errorMessage, isCodeNotFound);
    }
  }

  // Helper method to map error codes to user-friendly messages
  static String _getErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // First check errorMessage from server response
      String? errorMessage = responseData['errorMessage'];
      String? errorCode = responseData['errorCode'] ?? responseData['error'] ?? responseData['code'];
      
      // Use errorMessage directly if available, otherwise use errorCode mapping
      if (errorMessage != null && errorMessage.isNotEmpty) {
        switch (errorMessage) {
          case 'REFEREE_ALREADY_REDEEMED':
            return 'referral_already_redeemed'.tr();
          case 'REFERRAL_CODE_NOT_FOUND':
            return 'referral_code_not_found'.tr();
          case 'SELF_REFERRAL_NOT_ALLOWED':
            return 'this_code_cannot_be_redeemed'.tr();
          case 'NUMBER_REFEREES_EXCEEDS_MAXIMUM':
            return 'referees_exceeds_maximum'.tr();
          default:
            return errorMessage; // Use server message as-is for unknown errors
        }
      }
      
      // Fallback to errorCode mapping
      switch (errorCode) {
        case 'REFEREE_ALREADY_REDEEMED':
          return 'referral_already_redeemed'.tr();
        case 'REFERRAL_CODE_NOT_FOUND':
          return 'referral_code_not_found'.tr();
        case 'SELF_REFERRAL_NOT_ALLOWED':
          return 'this_code_cannot_be_redeemed'.tr();
        case 'NUMBER_REFEREES_EXCEEDS_MAXIMUM':
          return 'referees_exceeds_maximum'.tr();
        default:
          return responseData['message'] ?? 'referral_redeem_failed'.tr();
      }
    }
    return 'referral_redeem_failed'.tr();
  }
  
  // Helper method to check if error is REFERRAL_CODE_NOT_FOUND
  static bool _isCodeNotFound(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check errorMessage first (as server returns it there)
      String? errorMessage = responseData['errorMessage'];
      if (errorMessage != null && errorMessage == 'REFERRAL_CODE_NOT_FOUND') {
        return true;
      }
      
      // Fallback to errorCode
      String? errorCode = responseData['errorCode'] ?? responseData['error'] ?? responseData['code'];
      return errorCode == 'REFERRAL_CODE_NOT_FOUND';
    }
    return false;
  }
  
  // Helper method to check if response data contains error info
  static bool _hasErrorInData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check for common error fields
      return responseData.containsKey('errorCode') || 
             responseData.containsKey('error') || 
             responseData.containsKey('code') ||
             responseData.containsKey('errorMessage');
    }
    return false;
  }

  static Future<void> getReferralConfig({
    required Function(ReferralConfigModel) successCallback,
    Function? errorCallback,
  }) async {
    try {
      Response res = await ReferralApi.getReferralConfig();
      if (res.statusCode == 200) {
        successCallback(ReferralConfigModel.fromJson(res.data));
      } else {
        if (errorCallback != null) errorCallback(res.data);
      }
    } catch (e) {
      if (errorCallback != null) errorCallback(e);
    }
  }
}
