import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class LaboratoryChangeLanguage extends StatelessWidget {
  const LaboratoryChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.find<DebuggingController>();

    return DefaultContainer(
        titleText: 'change_country_region'.tr(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      title: StyledText('south_korea'.tr()),
                      value: 'ko',
                      groupValue: debuggingController.regionLanguage.value,
                      onChanged: (val) =>
                          debuggingController.setRegionLanguage(val!)),
                  RadioListTile(
                      title: StyledText('japan'.tr()),
                      value: 'ja',
                      groupValue: debuggingController.regionLanguage.value,
                      onChanged: (val) =>
                          debuggingController.setRegionLanguage(val!)),
                ],
              );
            }),
          ),
        ));
  }
}
