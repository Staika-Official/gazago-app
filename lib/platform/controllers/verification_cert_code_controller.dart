import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/verification_user_model.dart';
import 'package:gaza_go/platform/services/identity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as RX;

class VerificationCertCodeController extends GetxController {
  final RxString errorMsg = RxString('');
  final RxString _certCode = RxString('');
  final RxBool isFormValid = RxBool(false);
  final Rx<Duration> countdownTime = const Duration().obs;
  late VerificationUserModel verificationUserModel = Get.arguments['verificationUserModel'];
  final RxBool isNotNext = RxBool(false);
  int _requestId = -1;
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  RxString get countdownString {
    String formatCounter(counterString) => counterString.toString().padLeft(2, '0');
    String minutes = formatCounter(countdownTime.value.inMinutes);
    String seconds = formatCounter(countdownTime.value.inSeconds.remainder(60));
    return '$minutes:$seconds'.obs;
  }

  @override
  void onInit() {
    super.onInit();

    isFormValid.bindStream(RX.CombineLatestStream.combine2<String, Duration, bool>(_certCode.stream, countdownTime.stream, (code, count) => (code.length == 6) && (count.inSeconds != 0)));

    _requestId = Get.arguments['requestId'];
  }

  @override
  void onReady() {
    _startTimer();
    super.onReady();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void updateCertCode(String code) {
    _certCode.value = code;
  }

  void next() async {
    await IdentityService.verifyIdentityCode({"requestId": _requestId.toInt(), "code": _certCode.toString(), "clientId": "GAZAGO"}, successCallback: () {
      // 본인인증이 완료 이벤트
      Adjust.trackEvent(AdjustEvent('hed7a4'));

      HiveStore.save(key: HiveKey.certified.name, value: true);
      showToastPopup('본인인증이 완료되었습니다.');
      afterVerificationComplete();
    }, errorCallback: (res) {
      if (res.data['errorCode'] == 'IDENTITY_CI_ALREADY_EXISTS') {
        _timer.cancel();
        countdownTime.value = const Duration(minutes: 0);
        errorMsg.value = res.data['errorMessage'];
        isNotNext.value = true;
      }
      else if (res.data['errorCode'] == 'IDENTITY_ALREADY_VERIFIED') {
        showToastPopup(res.data['errorMessage']);
        afterVerificationComplete();
      }
      else if (res.data['errorCode'] == 'PENALTY_BLOCKED_USER') {
        showToastPopup(res.data['errorMessage']);
        forceLogout();
      } else {
        showInvalidCertCode(res.data['errorMessage']);
      }
    });
    HiveStore.deleteKey(key: HiveKey.enteredRoute.name);
  }

  void afterVerificationComplete() {
    String? enteredRoute = HiveStore.loadString(key: HiveKey.enteredRoute.name);

    if (enteredRoute != null && (enteredRoute.contains('challenge_detail')|| enteredRoute.contains('shop/item/detail')|| enteredRoute.contains('/activity/challenges')|| enteredRoute.contains('/wallet')) ) {
      Get.until((route) => Get.currentRoute == enteredRoute);
    } else {
      Get.until((route) => Get.currentRoute == Routes.home);
    }
  }

  void resendIdentityCode() async {
    await IdentityService.sendIdentityCode(verificationUserModel, successCallback: (requestId) {
      _requestId = requestId;
      _startTimer();
      showToastPopup('인증코드가 재전송되었습니다.');
    });
  }

  void _startTimer() {
    _timer.cancel();
    errorMsg.value = '';
    countdownTime.value = const Duration(minutes: 3);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownTime.value = countdownTime.value - const Duration(seconds: 1);
      if (countdownTime.value.inSeconds == 0) {
        timer.cancel();
        errorMsg.value = '인증번호가 만료 되었습니다. 다시 시도해주세요.';
      }
    });
  }
}
