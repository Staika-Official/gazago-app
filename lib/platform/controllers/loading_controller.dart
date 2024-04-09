import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/models/terms_status_model.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool underMaintenance = getConfig(dataType: ConfigType.bool, configKey: 'under_maintenance');
  bool hasEmergencyNotice = getConfig(dataType: ConfigType.bool, configKey: 'has_emergency_notice');

  @override
  void onInit() async {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);

    super.onInit();
  }

  @override
  void onReady() async {

    if (isUnderMaintenance()) {
      String emergencyNoticeContent = getConfig(dataType: ConfigType.string, configKey: 'emergency_notice_content');
      if (underMaintenance) {
        await BoardService.getNoticePopupList(
          successCallback: (List<NoticePopupModel> records) async {
            NoticePopupModel popup = records.firstWhere((element) => element.type == 'INSPECTION', orElse: () => NoticePopupModel(id: -1));
            if (popup.id != -1) {
              String rawText = popup.label!;
              String type = rawText.contains('|') ? rawText.split('|')[0] : 'ING';
              String contentText = rawText.contains('|') ? rawText.split('|')[1] : rawText;

              if (isShowMaintenancePreviewForToday()) {
                showMaintenanceAlert(
                  type: type,
                  contentText: contentText,
                  callbacks: type == 'PREVIEW'
                      ? [
                          () async {
                            Get.back();
                            await initLoading();
                          },
                          () async {
                            DateTime now = DateTime.now();
                            HiveStore.save(key: HiveKey.closeMaintenancePreviewDate.name, value: now);
                            Get.back();
                            await initLoading();
                          },
                        ]
                      : null,
                );
              } else {
                await initLoading();
              }
            } else {
              showMaintenanceAlert(type: 'EMERGENCY', contentText: emergencyNoticeContent);
            }
          },
          errorCallback: () {
            showMaintenanceAlert(type: 'EMERGENCY', contentText: emergencyNoticeContent);
          },
        );
      } else if (hasEmergencyNotice) {
        showMaintenanceAlert(type: 'EMERGENCY', contentText: emergencyNoticeContent);
      }
    } else {
      await initLoading();
    }
    super.onReady();
  }

  @override
  void onClose() {
    timerStop();
    super.onClose();
  }

  void showRestartAppPopup() async {
    timerStop();
    bool isInDebugMode = HiveStore.load(key: HiveKey.isDebuggingMode.name) ?? false;
    if (isInDebugMode) {
      await FirebaseCrashlytics.instance.recordError(Exception('LOADING ERROR'), StackTrace.current,
          information: [
            ...HiveStore.load(key: HiveKey.requestLogs.name),
            ...HiveStore.load(key: HiveKey.responseErrorLogs.name),
          ],
          fatal: true);
    } else {
      initDebugMode();
    }
    showRetryAlert(this);
  }

  Future<void> initLoading() async {
    DatabaseReference inspectionNoticeRef = FirebaseDatabase.instance.ref('inspectionNotice');
    await inspectionNoticeRef.get().then((DataSnapshot snapshot) async {
      if (snapshot.value == false) {
        await checkTermsAgreeStatus();
      }
    }).onError((error, stackTrace) {
      print(error);
    });

    Future.delayed(Duration.zero, () => timerStart());
  }

  void handleRefreshApp() {
    time.value = 0;
    retryCount.value = retryCount.value + 1;
    Get.back();
    if (Get.currentRoute != Routes.loading) Get.offAllNamed(Routes.loading);
    initLoading();
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

    await MemberService.getTermsAgreeStatus(
      successCallback: (termsList) {
        this.termsList.value = termsList;
        if (allRequiredAgreed.value) {
          if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().initializeController();
          if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().initializeController();
        } else {
          timerStop();
          Get.offNamed(Routes.joinTerms, arguments: {'platform': 'gazago'});
        }
      },
      errorCallback: (ErrorResponseDataModel? error) {
        if (error != null && error.status != 401) showToastPopup('약관 동의 여부를 확인할 수 없습니다.');
        timerStop();
        HiveStore.deleteMultipleKeys(keys: [
          HiveKey.accessToken.name,
          HiveKey.refreshToken.name,
        ]);
        Get.offNamed(Routes.login);
      },
    );
  }

  void updateProgress(String message) async {
    progress.value = progress.value + 0.5;
    progressMessage.value = message;

    print('progressMessage ${progressMessage.value}');

    if (progress.value >= 0.9) {
      timerStop();
      terminateDebugMode();
      print('11111111');
      Get.offAllNamed(Routes.home);
    }
  }

  bool isUnderMaintenance() {
    return underMaintenance || hasEmergencyNotice;
  }

  bool isShowMaintenancePreviewForToday() {
    DateTime? date = HiveStore.load(key: HiveKey.closeMaintenancePreviewDate.name);
    DateTime? viewableTime = date?.add(const Duration(hours: 24));
    DateTime now = DateTime.now();
    if (date == null || viewableTime!.isBefore(now)) {
      return true;
    }

    return false;
  }

  void initDebugMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: true);
  }

  void terminateDebugMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: false);
    HiveStore.save(key: HiveKey.requestLogs.name, value: []);
    HiveStore.save(key: HiveKey.responseErrorLogs.name, value: []);
    HiveStore.save(key: HiveKey.userExerciseDataLogs.name, value: []);
    HiveStore.save(key: HiveKey.positionRawDataLogs.name, value: []);
  }
}
