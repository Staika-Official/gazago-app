import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingController extends GetxController {
  final RxDouble progress = RxDouble(0);
  final RxString progressMessage = RxString("로드중......");

  @override
  void onInit() async {
    if (Get.isRegistered<WalletMasterController>()) Get.find<WalletMasterController>().onInit();
    if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().onInit();

    super.onInit();
  }

  void updateProgress(String message) async {
    progress.value = progress.value + 0.33;
    progressMessage.value = message;

    if (progress.value >= 0.9) {
      bool needForceUpgrade = await isForceUpdateTarget();
      if (needForceUpgrade) {
        Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: StyledText(
              '새 업데이트가 있습니다.',
              color: Colors.black,
            ),
            content: StyledText(
              '앱을 사용하기 위해서 업데이트가 필요합니다.',
              color: Colors.black,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
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
                child: StyledText(
                  '업데이트',
                  color: Colors.black,
                ),
              )
            ],
          ),
        );
      } else {
        bool needRecommendedUpgrade = await isRecommendUpdateTarget();
        if (needRecommendedUpgrade) {
          Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              title: StyledText(
                '새 업데이트가 있습니다.',
                color: Colors.black,
              ),
              content: StyledText(
                '앱을 사용하기 위해서 업데이트가 필요합니다.',
                color: Colors.black,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
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
                  child: StyledText(
                    '업데이트',
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  child: StyledText(
                    '무시하기',
                    color: Colors.black,
                  ),
                )
              ],
            ),
          );
        } else {
          Get.offAllNamed(Routes.home);
        }
      }
    }
  }
}
