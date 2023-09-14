import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class LaboratoryFakeGps extends StatelessWidget {
  const LaboratoryFakeGps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.find<DebuggingController>();

    return DefaultContainer(
        titleText: 'FAKE GPS 사용하기',
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(title: const StyledText('거부'), value: false, groupValue: debuggingController.allowFakeGps.value, onChanged: (val) => debuggingController.setGpsPermission(val!)),
                  RadioListTile(title: const StyledText('허용'), value: true, groupValue: debuggingController.allowFakeGps.value, onChanged: (val) => debuggingController.setGpsPermission(val!)),
                ],
              );
            }),
          ),
        ));
  }
}
