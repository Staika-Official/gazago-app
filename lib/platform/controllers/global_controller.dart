import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class GlobalController extends SuperController {
  final Rx<ConnectivityResult> connectivityResult = Rx(ConnectivityResult.none);
  StreamSubscription<ConnectivityResult>? connectivityStream;

  @override
  void onInit() async {
    await getConnectivity();
    initConnectivityStream();
    await checkLoginStatus();
    super.onInit();
  }

  @override
  void onDetached() {
    connectivityStream?.cancel();
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    connectivityStream?.cancel();
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() async {
    await getConnectivity();
    initConnectivityStream();
  }

  Future<void> getConnectivity() async {
    connectivityResult.value = await (Connectivity().checkConnectivity());
  }

  void initConnectivityStream() {
    connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityResult.value = result;
    });
  }

  Future<void> checkLoginStatus() async {
    String? accessToken = HiveStore.loadString(key: HiveKey.accessToken.name);
    if (accessToken != null) {
      await UaaService.checkLoginStatus(
        successCallback: () => null,
        errorCallback: () {
          Get.snackbar('로그인 만료', '로그인 유효시간이 만료되었습니다', colorText: Colors.white);
          Get.offAllNamed(Routes.login);
          HiveStore.deleteMultipleKeys(keys: [
            HiveKey.accessToken.name,
            HiveKey.refreshToken.name,
          ]);
        },
      );
    }
  }
}
