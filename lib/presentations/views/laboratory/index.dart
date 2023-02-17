import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../constants/enums.dart';
import '../../../constants/routes.dart';

class Laboratory extends StatelessWidget {
  const Laboratory({Key? key}) : super(key: key);

  List<Widget> renderActivityLogList(List<dynamic> logs) {
    return logs.isNotEmpty
        ? logs
            .map((log) => log['path'].contains('exercise') && !log['path'].contains('records')
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: StyledText(
                      log['logInfo']!,
                      lineHeight: 18,
                    ),
                  )
                : Container())
            .toList()
        : [Container()];
  }

  @override
  Widget build(BuildContext context) {
    DebuggingController debuggingController = Get.put(DebuggingController());

    return DefaultContainer(
      titleText: 'Laboratory',
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}
