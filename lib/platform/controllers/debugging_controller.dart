import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/access_token_model.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
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
      case 'positionRawDataLogs':
        HiveStore.save(key: HiveKey.positionRawDataLogs.name, value: []);
        break;
    }
  }

  void verifyLabPassword() {
    UaaService.verifyLabPassword(
      labPasswordController.text,
      successCallback: () {
        labPasswordController.text = '';
        isLabPasswordConfirmed.value = true;
      },
      errorCallback: () {
        isLabPasswordConfirmed.value = false;
        // showToastPopup('비밀번호가 틀렸습니다.');
      },
    );
  }

  Future<bool> verifyEndPointPassword() async {
    bool passwordVerified = false;
    await UaaService.requestLabSignIn(endPointPasswordController.text, successCallback: (AccessTokenModel token) {
      passwordVerified = true;
      HiveStore.save(key: HiveKey.accessToken.name, value: token.accessToken);
      HiveStore.save(key: HiveKey.refreshToken.name, value: token.refreshToken);
    }, errorCallback: () {
      passwordVerified = false;
      // showToastPopup('비밀번호가 틀렸습니다.');
    });
    Get.back();
    return passwordVerified;
  }

  void setEndPoint(EndPointType val) async {
    if (F.isDev && val != EndPointType.stage || !F.isDev && val != EndPointType.prod) {
      String savedEndPoint = HiveStore.load(key: HiveKey.endPointType.name) ?? (F.isDev ? EndPointType.stage.name : EndPointType.prod.name);
      HiveStore.save(key: HiveKey.endPointType.name, value: val.name);
      bool isPasswordConfirmed = await verifyEndPointPasswordAlert(this);
      if (isPasswordConfirmed) {
        endPointType.value = val;
        showToastPopup('2초 후 로딩화면으로 이동합니다.');
        Timer(Duration(seconds: 2), () async {
          await Get.put(LoginController()).getUserInfo();
          Get.offAllNamed(Routes.loading);
        });
      } else {
        HiveStore.save(key: HiveKey.endPointType.name, value: savedEndPoint);
      }
    } else {
      endPointType.value = val;
      HiveStore.save(key: HiveKey.endPointType.name, value: val.name);
      forceLogout();
    }
  }
}
