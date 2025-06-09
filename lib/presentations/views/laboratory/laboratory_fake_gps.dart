import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class LaboratoryFakeGps extends StatelessWidget {
  const LaboratoryFakeGps({super.key});

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.find<DebuggingController>();

    return DefaultContainer(
        titleText: 'use_fake_gps'.tr(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      title: StyledText('deny'.tr()),
                      value: false,
                      groupValue: debuggingController.allowFakeGps.value,
                      onChanged: (val) =>
                          debuggingController.setGpsPermission(val!)),
                  RadioListTile(
                      title: StyledText('allow'.tr()),
                      value: true,
                      groupValue: debuggingController.allowFakeGps.value,
                      onChanged: (val) =>
                          debuggingController.setGpsPermission(val!)),
                ],
              );
            }),
          ),
        ));
  }
}
