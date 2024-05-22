import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class LaboratoryKakaoShare extends StatelessWidget {
  const LaboratoryKakaoShare({super.key});

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.find<DebuggingController>();

    List<Widget> renderChallengeList() {
      return debuggingController.challengesList
          .map(
            (challenge) => RadioListTile(
                title: StyledText('${challenge.id}: ${challenge.title}'),
                value: challenge,
                groupValue: debuggingController.selectedChallenge.value,
                onChanged: (val) => debuggingController.selectChallenge(val!)),
          )
          .toList();
    }

    return DefaultContainer(
        titleText: '카톡 공유하기 테스트',
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...renderChallengeList(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: StyledText(debuggingController.shareUrl.value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GazagoButton(
                      onTap: () => debuggingController.shareChallenge(),
                      buttonText: '전송하기',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
