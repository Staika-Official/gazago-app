import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/presentations/components/bottom_sheet_alert.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_update/in_app_update.dart';

Future<void> showAlert({
  String? title,
  required List<Widget> actions,
  String? contentText,
  Widget? contentWidget,
  bool isScrollControlled = false,
  bool isDangerTitle = false,
  bool isNonePaddingOuter = false,
  bool isFullHeight = false,
  bool allowMultipleBottomSheet = false,
}) async {
  if (Get.isBottomSheetOpen == null ||
      !Get.isBottomSheetOpen! ||
      allowMultipleBottomSheet) {
    await Get.bottomSheet(
      PopScope(
        canPop: false,
        child: BottomSheetAlert(
          title: title,
          contentWidget: contentWidget,
          contentText: contentText,
          actions: actions,
          isDangerTitle: isDangerTitle,
          isNonePaddingOuter: isNonePaddingOuter,
          isFullHeight: isFullHeight,
        ),
      ),
      isDismissible: false,
      isScrollControlled: isScrollControlled,
      enableDrag: false,
    );
  }
}

void showToastPopup(String message) {
  Fluttertoast.showToast(
    timeInSecForIosWeb: 2,
    msg: message,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: 18.0,
  );
}

void showUpdateSnackbar() {
  Get.showSnackbar(
    GetSnackBar(
      isDismissible: false,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.9),
      titleText: StyledText(
        'download_complete'.tr(),
        fontSize: 14,
      ),
      messageText: StyledText(
        'update_available'.tr(),
        fontSize: 12,
      ),
      mainButton: TextButton(
        onPressed: () => InAppUpdate.completeFlexibleUpdate(),
        child: StyledText(
          'update'.tr(),
          fontSize: 12,
          color: skyBlueColor,
        ),
      ),
      onTap: (snackbar) {
        InAppUpdate.completeFlexibleUpdate();
      },
    ),
  );
}
