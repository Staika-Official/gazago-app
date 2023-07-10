import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class LaboratoryEndPoint extends StatelessWidget {
  const LaboratoryEndPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.put(DebuggingController());

    return DefaultContainer(
        titleText: '엔드포인트 변경',
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      title: const StyledText('STAGE'), value: EndPointType.stage, groupValue: debuggingController.endPointType.value, onChanged: (val) => debuggingController.setEndPoint(val!)),
                  RadioListTile(
                      title: const StyledText('PROD'), value: EndPointType.prod, groupValue: debuggingController.endPointType.value, onChanged: (val) => debuggingController.setEndPoint(val!))
                ],
              );
            }),
          ),
        ));
  }
}
