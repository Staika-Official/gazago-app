import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/terms_status_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxInt retryCount = RxInt(0);
  final RxDouble progress = RxDouble(0);
  final RxString progressMessage = RxString("로드중......");
  Timer? _timer;
  final RxInt time = RxInt(0);
  final RxList<TermsStatusModel> termsList = RxList.empty();
  RxBool get allRequiredAgreed {
    if (termsList.isNotEmpty &&
        termsList.singleWhere((term) => term.boardType == 'TERMS', orElse: () => TermsStatusModel(activated: false, boardType: 'TERMS')).activated &&
        termsList.singleWhere((term) => term.boardType == 'LOCATION', orElse: () => TermsStatusModel(activated: false, boardType: 'LOCATION')).activated &&
        termsList.singleWhere((term) => term.boardType == 'PRIVACY', orElse: () => TermsStatusModel(activated: false, boardType: 'PRIVACY')).activated) {
      return RxBool(true);
    } else {
      return RxBool(false);
    }
  }

  @override
  void onInit() async {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
    // 커넥션 타임아웃 체크를 위한 api 테스트 코드
    // int time = 0;
    // Timer connectionTimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   time = timer.tick;
    // });
    // await UaaService.pingConnection(11, successCallback: (data) {
    //   print(data);
    //   connectionTimer.cancel();
    //   print(time);
    // }, errorCallback: (data) {
    //   print(data);
    //   connectionTimer.cancel();
    //   print(time);
    // });
    await checkTermsAgreeStatus();

    super.onInit();
  }

  @override
  void onReady() {
    Future.delayed(Duration.zero, () => timerStart());
    super.onReady();
  }

  @override
  void onClose() {
    timerStop();
    super.onClose();
  }

  void showRestartAppPopup() {
    timerStop();
    showRetryAlert(this);
  }

  void handleRefreshApp() {
    time.value = 0;
    retryCount.value = retryCount.value + 1;
    Get.back();
    if (Get.currentRoute != Routes.loading) Get.offAllNamed(Routes.loading);
    timerStart();
  }

  void timerStart() {
    if (_timer != null) {
      _timer = null;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time.value++;

      if (!Get.isRegistered<LoadingController>()) {
        timerStop();
      }

      print('LoadingController time: ${time.value}');
      if (time.value > 60) {
        if (retryCount.value == 1) {
          showToastPopup('재시도에 실패하여 로그아웃 되었습니다.');
          forceLogout();
        } else {
          showRestartAppPopup();
          timerStop();
        }
      }
    });
  }

  void timerStop() {
    print('timerStop');
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> checkTermsAgreeStatus() async {
    await MemberService.getTermsAgreeStatus(successCallback: (termsList) {
      this.termsList.value = termsList;
      if (allRequiredAgreed.value) {
        if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().initializeController();
        if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().initializeController();
      } else {
        timerStop();
        Get.offNamed(Routes.joinTerms, arguments: {'platform': 'gazago'});
      }
    }, errorCallback: (ErrorResponseDataModel error) {
      if (error.status != 401) showToastPopup('약관 동의 여부를 확인할 수 없습니다.');
      timerStop();
      HiveStore.deleteMultipleKeys(keys: [
        HiveKey.accessToken.name,
        HiveKey.refreshToken.name,
      ]);
      Get.offNamed(Routes.login);
    });
  }

  void updateProgress(String message) async {
    progress.value = progress.value + 0.5;
    progressMessage.value = message;

    print('progressMessage ${progressMessage.value}');

    if (progress.value >= 0.9) {
      timerStop();
      Get.offAllNamed(Routes.home);
    }
  }
}
