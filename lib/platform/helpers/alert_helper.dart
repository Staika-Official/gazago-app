import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/bottom_sheet_alert.dart';
import 'package:get/get.dart';

Future<void> showAlert({
  required String title,
  required List<Widget> actions,
  String? contentText,
  Widget? contentWidget,
}) async {
  await Get.bottomSheet(
    BottomSheetAlert(title: title, contentWidget: contentWidget, contentText: contentText, actions: actions),
    isDismissible: false,
  );
}
