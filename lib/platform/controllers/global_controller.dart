import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart' hide Trans;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';

class GlobalController extends SuperController {
  // final Rx<ConnectivityResult> connectivityResult = Rx(ConnectivityResult.none);
  // StreamSubscription<ConnectivityResult>? connectivityStream;
  StreamSubscription<InternetConnectionStatus>? internetConnectionListener;

  // Create customized instance which can be registered via dependency injection
  final RxBool internetConnection = RxBool(false);
  final InternetConnectionChecker customInstance =
      InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  );
  final RxBool isPopupOpen = RxBool(true);
  final RxBool isNoticePopupOpen = RxBool(false);
  final RxBool showLoadingDialog = RxBool(false);

  @override
  void onInit() async {
    await checkMainPopupExpiredDate();
    await execute(customInstance);
    // await checkLoginStatus();

    // await getConnectivity();
    // initConnectivityStream();
    // 핸드폰이 강제 종료 되었을 경우 새로 더미스텝을 초기화시키기 위한 코드
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    showLoadingDialog.listen((isShow) {});

    super.onInit();
  }

  @override
  void onDetached() {
    // connectivityStream?.cancel();
    internetConnectionListener?.cancel();
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // connectivityStream?.cancel();
    // internetConnectionListener?.pause();
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
    Adjust.onPause();
  }

  @override
  void onResumed() async {
    Adjust.onResume();
    if (internetConnectionListener != null) {
      internetConnectionListener?.resume();
    } else {
      await execute(customInstance);
    }
  }

  Future<void> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    internetConnectionListener =
        internetConnectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            internetConnection.value = true;
            break;
          case InternetConnectionStatus.disconnected:
            internetConnection.value = false;
            showToastPopup('check_internet_connection'.tr());
            break;
        }
      },
    );
  }

  // Future<void> getConnectivity() async {
  //   connectivityResult.value = await Connectivity().checkConnectivity();
  // }
  //
  // void initConnectivityStream() {
  //   connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //     connectivityResult.value = result;
  //   });
  // }

  Future<void> checkLoginStatus() async {
    String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);
    if (accessToken != null) {
      await UaaService.checkLoginStatus(
        successCallback: () => null,
        errorCallback: () {
          showToastPopup('login_session_expired'.tr());
          HiveStore.deleteMultipleKeys(keys: [
            HiveKey.accessToken.name,
            HiveKey.refreshToken.name,
          ]);
          if (Get.currentRoute != Routes.login) Get.offAllNamed(Routes.login);
        },
      );
    }
  }

  Future<void> checkMainPopupExpiredDate() async {
    DateTime? date = await HiveStore.load(key: HiveKey.closePopupDate.name);
    if (date != null) {
      DateTime viewableTime = date.add(const Duration(hours: 24));
      DateTime now = DateTime.now();
      if (viewableTime.isBefore(now)) {
        isPopupOpen.value = true;
      } else {
        isPopupOpen.value = false;
      }
    } else {
      isPopupOpen.value = true;
    }
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
