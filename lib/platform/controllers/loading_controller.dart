import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/terms_status_model.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingController extends GetxController {
  final RxDouble progress = RxDouble(0);
  final RxString progressMessage = RxString("로드중......");
  Timer? _timer;
  final RxInt time = RxInt(0);
  final RxList<TermsStatusModel> termsList = RxList.empty();
  RxBool get allRequiredAgreed {
    if (termsList.singleWhere((term) => term.boardType == 'TERMS').activated &&
        termsList.singleWhere((term) => term.boardType == 'LOCATION').activated &&
        termsList.singleWhere((term) => term.boardType == 'PRIVACY').activated) {
      return RxBool(true);
    } else {
      return RxBool(false);
    }
  }

  @override
  void onInit() async {
    await checkTermsAgreeStatus();
    if (allRequiredAgreed.value) {
      if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().onInit();
      if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().onInit();
    } else {
      Get.toNamed(Routes.joinTerms);
    }

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

      print(Get.isRegistered<LoadingController>());
      if (!Get.isRegistered<LoadingController>()) {
        timerStop();
      }

      print('LoadingController time: ${time.value}');
      if (time.value > 60) {
        showRestartAppPopup();
        timerStop();
      }
    });
  }

  void timerStop() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> checkTermsAgreeStatus() async {
    await MemberService.getTermsAgreeStatus(successCallback: (termsList) {
      this.termsList.value = termsList;
    }, errorCallback: () {
      showToastPopup('약관 동의 여부를 확인할 수 없습니다.');
      Get.toNamed(Routes.login);
    });
  }

  void updateProgress(String message) async {
    progress.value = progress.value + 0.5;
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
                    final url = Uri.parse(
                      Platform.isAndroid ? "https://gazago.page.link/update_android" : "https://gazago.page.link/update_ios",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                buttonText: '업데이트',
                buttonColor: skyBlueColor,
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
                  buttonColor: popupBgColor,
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Expanded(
                child: GazagoButton(
                  onTap: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      final url = Uri.parse(
                        Platform.isAndroid ? "https://gazago.page.link/update_android" : "https://gazago.page.link/update_ios",
                      );
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  buttonText: '업데이트',
                  buttonColor: skyBlueColor,
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
