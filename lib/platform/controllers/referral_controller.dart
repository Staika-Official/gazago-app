import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/preference_mixin.dart';
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

  // Pagination state
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var hasMoreData = true.obs;
  var isLoadingMore = false.obs;
  var pageSize = 10;

  @override
  void onInit() async {
    await getProfileInfo();
    await init();

    super.onInit();
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
        showToastPopup('Không thể lấy referral code');
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
        showToastPopup('Không thể tải danh sách referees');

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
    // TODO: Implement API call to redeem referral code

    // Validate code format first
    if (!_isValidReferralCodeFormat(code)) {
      return false;
    }

    // Gọi server API để redeem code
    // await ReferralService.redeemCode(code, ...)

    // Placeholder - chầm implement API
    return true;
  }

  /// Validate referral code format
  bool _isValidReferralCodeFormat(String code) {
    return code.isNotEmpty && code.trim().isNotEmpty;
  }
}
