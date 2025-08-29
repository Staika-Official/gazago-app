import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/referral_history_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
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
    myReferralCode.value = 'A2ZAO5';
    canCopyCode.value = true;
  }

  Future<void> _fetchReferralHistory() async {
    await Future.delayed(2.seconds);
    historyList.value = List.generate(
      15,
      (index) => ReferralHistoryModel(
        id: index,
        name: 'John Doe',
        points: 10,
        isClaimed: index % 2 == 0,
      ),
    );
  }

  Future<void> onCodeCopied() async {
    canCopyCode.value = false;

    try {
      await FlutterClipboard.copy(myReferralCode.value);

      // show toast
      // showToastWithIcon(
      //   icon: iconCheckOutlineWhite,
      //   message: 'code_copied'.tr(),
      //   backgroundColor: bgAlertGreen,
      // );
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
}
