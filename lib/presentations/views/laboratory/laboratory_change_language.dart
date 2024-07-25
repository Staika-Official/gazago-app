import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class LaboratoryChangeLanguage extends StatelessWidget {
  const LaboratoryChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.find<DebuggingController>();

    return DefaultContainer(
        titleText: '국가/지역 변경하기',
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(title: const StyledText('한국'), value: 'ko', groupValue: debuggingController.regionLanguage.value, onChanged: (val) => debuggingController.setRegionLanguage(val!)),
                  RadioListTile(title: const StyledText('일본'), value: 'ja', groupValue: debuggingController.regionLanguage.value, onChanged: (val) => debuggingController.setRegionLanguage(val!)),
                ],
              );
            }),
          ),
        ));
  }
}
