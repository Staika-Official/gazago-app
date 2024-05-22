import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RequestInfo extends StatelessWidget {
  const RequestInfo({super.key});

  List<Widget> renderRequestLogList(List<dynamic> logs) {
    return logs.isNotEmpty
        ? logs
            .map((log) => !log['path'].contains('exercise') || log['path'].contains('records')
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
      titleText: 'Request Info',
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
                      onTap: () => debuggingController.handleInitLogs('requestLogs'),
                      buttonText: '초기화',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  Expanded(
                    child: GazagoButton(
                      onTap: () => debuggingController.onDisableDebuggingMode(),
                      buttonText: '멈춤',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  Expanded(
                    child: GazagoButton(
                      onTap: () => debuggingController.onEnableDebuggingMode(),
                      buttonText: '시작',
                      buttonColor: skyBlueColor,
                    ),
                  ),
                  // Expanded(
                  //   child: GazagoButton(
                  //     onTap: () => null,
                  //     buttonText: '전송',
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
                      ...renderRequestLogList(box.get(HiveKey.requestLogs.name) ?? []),
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
