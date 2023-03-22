import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DebuggingController extends GetxController {
  int doubleTouchCount = 0;
  final RxBool isShowDebuggingMenu = RxBool(false);
  final RxBool isLabPasswordConfirmed = RxBool(false);
  final TextEditingController labPasswordController = TextEditingController();
  final TextEditingController endPointPasswordController = TextEditingController();
  final Rx<EndPointType> endPointType = Rx(EndPointType.stage);

  @override
  void onInit() async {
    isShowDebuggingMenu.value = HiveStore.load(key: HiveKey.isDebuggingMode.name);
    endPointType.value = F.baseUrl.contains('api.stage') ? EndPointType.stage : EndPointType.prod;
    super.onInit();
  }

  void onDebuggingModeTouchCount() async {
    doubleTouchCount++;
    if (doubleTouchCount == 3) {
      Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
        showToastPopup('앱 캐시가 삭제 되었습니다.');
      }
    }
    if (doubleTouchCount > 4) {
      isShowDebuggingMenu.value = true;
      HiveStore.save(key: HiveKey.isShowDebuggingMenu.name, value: true);
      HiveStore.save(key: HiveKey.isDebuggingMode.name, value: true);
      doubleTouchCount = 0;
    }
  }

  void onDisableDebuggingMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: false);
  }

  void onEnableDebuggingMode() {
    HiveStore.save(key: HiveKey.isDebuggingMode.name, value: true);
  }

  void handleInitLogs(String key) {
    switch (key) {
      case 'requestLogs':
        HiveStore.save(key: HiveKey.requestLogs.name, value: []);
        break;
      case 'responseErrorLogs':
        HiveStore.save(key: HiveKey.responseErrorLogs.name, value: []);
        break;
      case 'userExerciseDataLogs':
        HiveStore.save(key: HiveKey.userExerciseDataLogs.name, value: []);
        break;
      case 'positionLowDataLogs':
        HiveStore.save(key: HiveKey.positionLowDataLogs.name, value: []);
        break;
    }
  }

  void verifyLabPassword() {
    if (labPasswordController.text == 'Eztechfin') {
      labPasswordController.text = '';
      isLabPasswordConfirmed.value = true;
    }
  }

  Future<bool> verifyEndPointPassword() async {
    bool passwordVerified = false;
    if (endPointPasswordController.text == 'Eztechfin') {
      await Future.delayed(Duration(seconds: 2), () {
        passwordVerified = true;
      });
    } else {
      await Future.delayed(Duration(seconds: 2), () {
        passwordVerified = false;
      });
    }

    Get.back();
    return passwordVerified;
  }

  void setEndPoint(EndPointType val) async {
    if (F.isDev && val != EndPointType.stage || !F.isDev && val != EndPointType.prod) {
      bool isPasswordConfirmed = await verifyEndPointPasswordAlert(this);
      if (isPasswordConfirmed) {
        endPointType.value = val;
        HiveStore.save(key: HiveKey.endPointType.name, value: val.name);
      }
    } else {
      endPointType.value = val;
      HiveStore.save(key: HiveKey.endPointType.name, value: val.name);
      forceLogout();
    }
  }
}
