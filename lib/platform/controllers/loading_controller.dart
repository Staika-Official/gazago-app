import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingController extends GetxController {
  final RxDouble progress = RxDouble(0);
  final RxString progressMessage = RxString("로드중......");
  Timer? _timer;
  final RxInt time = RxInt(0);

  @override
  void onInit() async {
    if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().onInit();
    if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().onInit();
    timerStart();

    super.onInit();
  }

  @override
  void dispose() {
    timerStop();
    super.dispose();
  }

  @override
  void onClose() {
    timerStop();
    super.onClose();
  }

  void showRestartAppPopup() {
    timerStop();
    showAlert(
      title: '로딩 중 오류가 발생했습니다',
      contentText: '재시도 후에도 오류가 발생할 경우\n잠시 후 다시 시도해 주세요',
      actions: [
        Expanded(
          child: GazagoButton(
            onTap: () => {handleRefreshApp()},
            buttonText: '재시도하기',
            buttonColor: const Color(0xFF0EE6F3),
          ),
        ),
      ],
    );
  }

  void handleRefreshApp() {
    time.value = 0;
    Get.back();
    Get.offAllNamed(Routes.loading);
    timerStart();
  }

  void timerStart() {
    if (_timer != null) {
      _timer = null;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time.value++;

      print('LoadingController time: ${time.value}');
      if (time.value > 60) {
        showRestartAppPopup();
        timerStop();
      }
    });
  }

  void timerStop() {
    _timer?.cancel();
    _timer = null;
  }

  void updateProgress(String message) async {
    progress.value = progress.value + 0.33;
    progressMessage.value = message;

    if (progress.value >= 0.9) {
      bool needForceUpgrade = await isForceUpdateTarget();
      if (needForceUpgrade) {
        timerStop();
        showAlert(
          title: '새 업데이트가 있습니다.',
          contentText: '앱을 사용하기 위해서 업데이트가 필요합니다.',
          actions: [
            Expanded(
              child: GazagoButton(
                onTap: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid ? 'kr.co.eztechfin.gazaGo' : 'kr.co.eztechfin.gazaGo';
                    final url = Uri.parse(
                      Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                buttonText: '업데이트',
                buttonColor: const Color(0xFF0EE6F3),
              ),
            ),
          ],
        );
      } else {
        bool needRecommendedUpgrade = await isRecommendUpdateTarget();
        if (needRecommendedUpgrade) {
          timerStop();
          showAlert(
            title: '새 업데이트가 있습니다.',
            contentText: '앱을 사용하기 위해서 업데이트가 필요합니다.',
            actions: [
              Expanded(
                child: GazagoButton(
                  onTap: () => Get.offAllNamed(Routes.home),
                  buttonText: '무시하기',
                  textColor: Colors.white,
                  buttonColor: const Color(0xFF363841),
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Expanded(
                child: GazagoButton(
                  onTap: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid ? 'kr.co.eztechfin.gazaGo' : 'kr.co.eztechfin.gazaGo';
                      final url = Uri.parse(
                        Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId",
                      );
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  buttonText: '업데이트',
                  buttonColor: const Color(0xFF0EE6F3),
                ),
              ),
            ],
          );
        } else {
          timerStop();
          Get.offAllNamed(Routes.home);
        }
      }
    }
  }
}
