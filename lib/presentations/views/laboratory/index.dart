import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

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
                        onSubmitted: (String text) => debuggingController.verifyLabPassword(),
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
                        child: GazagoButton(buttonText: '확인', onTap: () => debuggingController.verifyLabPassword()),
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
                      onTap: () => Get.toNamed(Routes.laboratorySolanaCreateWallet),
                      buttonText: '솔라나 지갑 생성',
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratorySolanaTransfer),
                      buttonText: '솔라나(토큰) 전송',
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryEndPoint),
                      buttonText: '엔드포인트 변경',
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryFakeGps),
                      buttonText: 'FAKE GPS 사용하기',
                      buttonColor: skyBlueColor,
                    ),
                    GazagoButton(
                      onTap: () => Get.toNamed(Routes.laboratoryKakaoShare),
                      buttonText: '카톡 공유하기',
                      buttonColor: skyBlueColor,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
