import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import '../../../constants/routes.dart';

class Laboratory extends StatelessWidget {
  const Laboratory({super.key});

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.put(DebuggingController());

    return Obx(() {
      return DefaultContainer(
        titleText: 'Laboratory',
        backgroundColor: subBg01Color,
        headerBackgroundColor: const Color(0xFF23232D),
        child: !debuggingController.isLabPasswordConfirmed.value
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onSubmitted: (String text) =>
                            debuggingController.verifyLabPassword(),
                        decoration: const InputDecoration(
                          focusColor: skyBlueColor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: skyBlueColor,
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.go,
                        controller: debuggingController.labPasswordController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GazagoButton(
                            buttonText: 'confirm'.tr(),
                            onTap: () =>
                                debuggingController.verifyLabPassword()),
                      )
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GazagoButton(
                      onTap: () =>
                          Get.toNamed(Routes.laboratorySolanaCreateWallet),
                      buttonText: 'create_solana_wallet'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratorySolanaTransfer),
                      buttonText: 'send_solana_tokens'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryEndPoint),
                      buttonText: 'change_endpoint'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryFakeGps),
                      buttonText: 'use_fake_gps'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryKakaoShare),
                      buttonText: 'share_on_kakao'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () =>
                          Get.toNamed(Routes.laboratoryDetectChallengeCourse),
                      buttonText: 'check_challenge_course'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryChangeLanguage),
                      buttonText: 'change_country_region'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
