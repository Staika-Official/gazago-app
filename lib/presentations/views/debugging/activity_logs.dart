import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../constants/enums.dart';

class ActivityLogs extends StatelessWidget {
  const ActivityLogs({super.key});

  List<Widget> renderActivityLogList(List<dynamic> logs) {
    return logs.isNotEmpty
        ? logs
            .map((log) => log['path'].contains('exercise') &&
                    !log['path'].contains('records')
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
      titleText: 'Exercise Logs',
      backgroundColor: subBg01Color,
      headerBackgroundColor: const Color(0xFF23232D),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GazagoButton(
                      onTap: () =>
                          debuggingController.handleInitLogs('requestLogs'),
                      buttonText: 'reset'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  Expanded(
                    child: GazagoButton(
                      onTap: () => debuggingController.onDisableDebuggingMode(),
                      buttonText: 'pause'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  Expanded(
                    child: GazagoButton(
                      onTap: () => debuggingController.onEnableDebuggingMode(),
                      buttonText: 'start'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  // Expanded(
                  //   child: GazagoButton(
                  //     onTap: () => null,
                  //     buttonText: 'send'.tr(),
                  //     buttonColor: skyBlueColor,
                  //   ),
                  // )
                ],
              ),
              ValueListenableBuilder<Box>(
                valueListenable: Hive.box('gazaGo').listenable(),
                builder: (context, box, widget) {
                  return Column(
                    children: [
                      ...renderActivityLogList(
                          box.get(HiveKey.requestLogs.name) ?? []),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
