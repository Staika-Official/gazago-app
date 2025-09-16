import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/preference_mixin.dart';
import 'package:gaza_go/presentations/components/overlay_dialog.dart';
import 'package:gaza_go/platform/models/referee_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/referral_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:get/get.dart' hide Trans;

class ReferralController extends GetxController with PreferenceMixin {
  var isLoading = true.obs;
  var myReferralCode = ''.obs;
  var canCopyCode = false.obs;
  var refereesList = <RefereeModel>[].obs;
  var refereesLoading = false.obs;
  var isRedeemingReferralCode = false.obs;

  // Add TextEditingController for referral code input
  late TextEditingController referralCodeController;

  // Pagination state
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var hasMoreData = true.obs;
  var isLoadingMore = false.obs;
  var pageSize = 10;

  @override
  void onInit() async {
    referralCodeController = TextEditingController();
    await getProfileInfo();
    await init();

    super.onInit();
  }

  @override
  void onClose() {
    referralCodeController.dispose();
    super.onClose();
  }

  Future<void> init() async {
    isLoading.value = true;
    await Future.wait([
      _fetchMyReferralCode(),
      _fetchReferees(),
    ]);
    isLoading.value = false;
  }

  Future<void> _fetchMyReferralCode() async {
    await UaaService.getAccountInfo(
      successCallback: (UserAccountModel account) {
        myReferralCode.value = account.userCode ?? '';
        canCopyCode.value = true;
      },
      errorCallback: (error) {
        canCopyCode.value = false;
      },
    );
  }

  Future<void> _fetchReferees({int? page, int? size}) async {
    final requestPage = page ?? currentPage.value;
    final requestSize = size ?? pageSize;

    if (profile.value.id <= 0) {
      refereesLoading.value = false;
      return;
    }

    if (requestPage == 0) {
      refereesLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    await ReferralService.getReferees(
      profile.value.id.toString(),
      page: requestPage,
      size: requestSize,
      successCallback: (RefereeResponseModel response) {
        currentPage.value = response.meta.page;
        totalPages.value = response.meta.totalPages;
        hasMoreData.value = response.meta.hasNext;

        if (requestPage == 0) {
          refereesList.value = response.data;
          refereesLoading.value = false;
        } else {
          refereesList.addAll(response.data);
          isLoadingMore.value = false;
        }
      },
      errorCallback: (error) {
        if (requestPage == 0) {
          refereesLoading.value = false;
        } else {
          isLoadingMore.value = false;
        }
      },
    );
  }

  /// Load more referees (next page)
  Future<void> loadMoreReferees() async {
    if (!hasMoreData.value || isLoadingMore.value) {
      return;
    }

    final nextPage = currentPage.value + 1;
    await _fetchReferees(page: nextPage);
  }

  /// Refresh referees list (reload from page 0)
  Future<void> refreshReferees() async {
    currentPage.value = 0;
    hasMoreData.value = true;
    await _fetchReferees(page: 0);
  }

  Future<void> onCodeCopied() async {
    canCopyCode.value = false;

    try {
      await FlutterClipboard.copy(myReferralCode.value);

      // show toast
      showToastV2(
        message: 'code_copied'.tr(),
      );
    } on ClipboardException catch (e) {
      log('Copy failed: ${e.message}');
    }

    Future.delayed(2.seconds).whenComplete(
      () {
        canCopyCode.value = true;
      },
    );
  }

  void onClaimCodeReward(int id) {
    // call api to claim reward
  }

  Future<bool> redeemReferralCode(String code) async {
    // Validate code format first
    if (!_isValidReferralCodeFormat(code)) {
      // For invalid format, show error directly in the dialog (not overlay)
      showToastPopup('invalid_code_format'.tr());
      return false;
    }

    // Check if user profile is available
    if (profile.value.id <= 0) {
      showToastPopup('user_info_not_found'.tr());
      return false;
    }

    isRedeemingReferralCode.value = true;
    bool success = false;

    await ReferralService.redeemReferralCode(
      profile.value.id.toString(),
      code.trim(),
      successCallback: () {
        success = true;
        // Clear input field
        referralCodeController.clear();
        // Refresh referees list to show updated data
        refreshReferees();
        // Show success dialog
        OverlayDialog.showSuccess(
          title: 'awesome'.tr(),
          description: 'referral_redeem_success'.tr(),
        );
      },
      errorCallback: (String errorMessage, bool isCodeNotFound) {
        success = false;
        // Note: Error handling is now done in UI layer (RedeemCodeBottomSheet)
        // This callback is kept for backward compatibility but does nothing
        // to avoid duplicate error dialogs
      },
    );

    isRedeemingReferralCode.value = false;
    return success;
  }

  /// Validate referral code format
  bool _isValidReferralCodeFormat(String code) {
    final trimmedCode = code.trim().toUpperCase();
    // Validation: exactly 8 characters, alphanumeric only
    return trimmedCode.length == 8 &&
        RegExp(r'^[A-Z0-9]{8}$').hasMatch(trimmedCode);
  }
}
