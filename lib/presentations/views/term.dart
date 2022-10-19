import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/term_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Term extends StatelessWidget {
  const Term({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TermController controller = Get.put(TermController());

    return Obx(() {
      return DefaultContainer(
        titleText: controller.termTitle.value,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(25),
            child: StyledText(
              controller.termContent.value,
              fontSize: 16,
              fontWeight: 500,
              lineHeight: 24,
              letterSpacing: -0.5,
            ),
          ),
        ),
      );
    });
  }
}
