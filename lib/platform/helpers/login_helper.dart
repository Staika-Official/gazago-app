import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

Color getLoginButtonColor(String loginType) {
  switch (loginType) {
    case 'apple':
      return const Color(0xFF1E1E1C);
    case 'google':
      return Colors.white;
  }
  return const Color(0xFFffffff);
}

String getLoginButtonText(String loginType) {
  switch (loginType) {
    case 'apple':
      return 'Apple';
    case 'google':
      return 'Google';
  }
  return '이메일';
}

SvgPicture getLoginButtonIcon(String loginType) {
  switch (loginType) {
    case 'apple':
      return iconLoginApple;
    case 'google':
      return iconLoginGoogle;
  }
  return iconLoginGoogle;
}

void handleKeysOnLogout() {
  HiveStore.deleteMultipleKeys(keys: [
    HiveKey.accessToken.name,
    HiveKey.refreshToken.name,
    HiveKey.userState.name,
    HiveKey.exerciseData.name,
    HiveKey.endExerciseRequested.name,
    HiveKey.badgeIssuanceRequested.name,
    HiveKey.savedStepCount.name,
    HiveKey.dummyStepCount.name,
    HiveKey.savedStepInitialized.name,
    HiveKey.authorities.name,
  ]);
}

void forceLogout() async {
  handleKeysOnLogout();

  Get.offAllNamed(Routes.login);
}
