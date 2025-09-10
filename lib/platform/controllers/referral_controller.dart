import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/referral_history_model.dart';
import 'package:get/get.dart' hide Trans;

class ReferralController extends GetxController {
  var isLoading = true.obs;
  var myReferralCode = ''.obs;
  var canCopyCode = false.obs;
  var historyList = <ReferralHistoryModel>[].obs;

  Future<void> init() async {
    isLoading.value = true;
    await Future.wait([
      _fetchMyReferralCode(),
      _fetchReferralHistory(),
    ]);
    isLoading.value = false;
  }

  Future<void> _fetchMyReferralCode() async {
    // fake api call
    await Future.delayed(2.seconds);
    myReferralCode.value = _generateReferralCode();
    canCopyCode.value = true;
  }

  /// Generate 8-character uppercase alphanumeric referral code as per spec
  String _generateReferralCode() {
    // For demo purposes, using a fixed code. In real app, this would come from API
    // Format: exactly 8 characters, uppercase alphanumeric (A-Z, 0-9)
    return '1X6E1DKL'; // Example from spec: exactly 8 characters
  }

  Future<void> _fetchReferralHistory() async {
    await Future.delayed(2.seconds);
    
    // Mock realistic referral history data
    final mockNames = [
      'Alice Johnson', 'Bob Smith', 'Charlie Brown', 'Diana Prince',
      'Edward Wilson', 'Fiona Davis', 'George Miller', 'Helen Clark',
      'Ian Thompson', 'Julia Adams', 'Kevin Lee', 'Laura Garcia',
      'Michael Chen', 'Nancy White', 'Oliver Martinez'
    ];
    
    historyList.value = List.generate(
      mockNames.length,
      (index) => ReferralHistoryModel(
        id: index,
        name: mockNames[index],
        points: 10, // Fixed 10 Gem as per spec
        isClaimed: true, // All show as "Claimed" status
      ),
    );
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
    // For now, simulate API call with delay
    await Future.delayed(1.seconds);

    // Validate code format: exactly 8 characters, uppercase alphanumeric
    if (!_isValidReferralCodeFormat(code)) {
      return false;
    }

    // Mock validation with 8-character test codes
    final validTestCodes = ['ABCD1234', 'TEST2025', '1X6E1DKL'];
    if (validTestCodes.contains(code)) {
      return true;
    }

    return false;
  }

  /// Validate referral code format: exactly 8 characters, uppercase alphanumeric
  bool _isValidReferralCodeFormat(String code) {
    if (code.length != 8) return false;
    final regex = RegExp(r'^[A-Z0-9]{8}$');
    return regex.hasMatch(code);
  }
}
