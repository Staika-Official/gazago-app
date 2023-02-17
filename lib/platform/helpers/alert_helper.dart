import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/presentations/components/bottom_sheet_alert.dart';
import 'package:get/get.dart';

Future<void> showAlert({
  String? title,
  required List<Widget> actions,
  String? contentText,
  Widget? contentWidget,
  bool isScrollControlled = false,
  bool isDangerTitle = false,
  bool isNonePaddingOuter = false,
}) async {
  await Get.bottomSheet(
    WillPopScope(
      onWillPop: () async => false,
      child: BottomSheetAlert(
        title: title,
        contentWidget: contentWidget,
        contentText: contentText,
        actions: actions,
        isDangerTitle: isDangerTitle,
        isNonePaddingOuter: isNonePaddingOuter,
      ),
    ),
    isDismissible: false,
    isScrollControlled: isScrollControlled,
    enableDrag: false,
  );
}

void showToastPopup(String message) {
  Fluttertoast.showToast(
    timeInSecForIosWeb: 2,
    msg: message,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.black.withOpacity(0.9),
    textColor: Colors.white,
    fontSize: 18.0,
  );
}
