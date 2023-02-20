import 'dart:async';

import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class GlobalController extends SuperController {
  // final Rx<ConnectivityResult> connectivityResult = Rx(ConnectivityResult.none);
  // StreamSubscription<ConnectivityResult>? connectivityStream;
  StreamSubscription<InternetConnectionStatus>? internetConnectionListener;
  // Create customized instance which can be registered via dependency injection
  final RxBool internetConnection = RxBool(false);
  final InternetConnectionChecker customInstance = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  );
  final RxBool isPopupOpen = RxBool(true);
  @override
  void onInit() async {
    checkMainPopupExpiredDate();
    await execute(InternetConnectionChecker());
    await execute(customInstance);
    await checkLoginStatus();

    // await getConnectivity();
    // initConnectivityStream();

    super.onInit();
  }

  void onReady() {
    print('Ready GlobalController');
    super.onReady();
  }

  @override
  void onDetached() {
    print('onDetached GlobalController');
    // connectivityStream?.cancel();
    internetConnectionListener?.cancel();
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    print('onInactive GlobalController');
    // connectivityStream?.cancel();
    internetConnectionListener?.cancel();
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    print('onPaused GlobalController');
    // TODO: implement onPaused
  }

  @override
  void onResumed() async {
    print('onResumed GlobalController');
    await execute(customInstance);
    // await getConnectivity();
    // initConnectivityStream();
  }

  Future<void> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    internetConnectionListener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            internetConnection.value = true;
            break;
          case InternetConnectionStatus.disconnected:
            internetConnection.value = false;
            showToastPopup('인터넷 상태를 확인해주세요.');
            break;
        }
      },
    );

    await Future<void>.delayed(const Duration(seconds: 30));
    await internetConnectionListener?.cancel();
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
          showToastPopup('로그인 유효시간이 만료되었습니다');
          HiveStore.deleteMultipleKeys(keys: [
            HiveKey.accessToken.name,
            HiveKey.refreshToken.name,
          ]);
          if (Get.currentRoute != Routes.login) Get.offAllNamed(Routes.login);
        },
      );
    }
  }

  void checkMainPopupExpiredDate() {
    DateTime? date = HiveStore.load(key: HiveKey.closePopupDate.name);
    DateTime? viewableTime = date?.add(const Duration(hours: 24));
    DateTime now = DateTime.now();
    if (date == null || viewableTime!.isBefore(now)) {
      isPopupOpen.value = true;
    } else {
      isPopupOpen.value = false;
    }
  }
}
