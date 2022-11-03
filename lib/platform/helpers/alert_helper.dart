import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/presentations/components/bottom_sheet_alert.dart';
import 'package:get/get.dart';

Future<void> showAlert({
  required String title,
  required List<Widget> actions,
  String? contentText,
  Widget? contentWidget,
  bool isScrollControlled = false,
}) async {
  await Get.bottomSheet(
    BottomSheetAlert(title: title, contentWidget: contentWidget, contentText: contentText, actions: actions),
    isDismissible: false,
    isScrollControlled: isScrollControlled,
    backgroundColor: Color(0xff363841),
  );
}

void showToastPopup(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.black.withOpacity(0.9),
    textColor: Colors.white,
    fontSize: 18.0,
  );
}
