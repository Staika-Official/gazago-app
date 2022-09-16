import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';

class LoginController extends GetxController {
  void login(LoginType loginType) async {
    showDuplicateLoginWarning();
  }

  void showDuplicateLoginWarning() {
    Get.dialog(
      AlertDialog(
        title: const Text('확인해 주세요'),
        content: const Text('댜른 기기에 로그인 되어있습니다.\n해당 기기의 로그인을 헤제 후 로그인 하시겠습니까?'),
        actions: [
          ElevatedButton(onPressed: () => showLogoutConfirmation(), child: const Text('아니요')),
          ElevatedButton(onPressed: () => Get.offNamed(Routes.onBoarding), child: const Text('네')),
        ],
      ),
    );
  }

  void showLogoutConfirmation() {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('알림'),
        content: const Text('사용 중인 계정이 다른 기기에서.\n접속이 종료 되었습니다.?'),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('확인')),
        ],
      ),
    );
  }
}
