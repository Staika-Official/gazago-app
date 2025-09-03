import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaza_go/presentations/components/bottom_sheet_alert.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
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

enum ToastV2Type { error, success }

// Global variable to track sticky toast state
GetSnackBar? _stickyNetworkToast;

void showToastV2({
  required String message,
  ToastV2Type type = ToastV2Type.success,
}) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: () {
                switch (type) {
                  case ToastV2Type.error:
                    return AppColorData.regular().colorIconWarning;
                  case ToastV2Type.success:
                    return AppColorData.regular().colorPointGreen;
                }
              }(),
            ),
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    () {
                      switch (type) {
                        case ToastV2Type.error:
                          return Icons.cancel;
                        case ToastV2Type.success:
                          return Icons.check_circle;
                      }
                    }(),
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: 2.seconds,
      backgroundColor: Colors.transparent,
    ),
  );
}

/// Show sticky network status toast that stays until network is restored
void showStickyNetworkToast({required bool isConnected}) {
  if (isConnected) {
    // Hide sticky toast if exists
    if (_stickyNetworkToast != null) {
      Get.closeCurrentSnackbar();
      _stickyNetworkToast = null;
    }

    // Show success toast briefly
    showToastV2(
      message: 'network_connected'.tr(),
      type: ToastV2Type.success,
    );
  } else {
    // Hide any existing sticky toast first
    if (_stickyNetworkToast != null) {
      Get.closeCurrentSnackbar();
    }

    // Create and show sticky error toast
    _stickyNetworkToast = GetSnackBar(
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColorData.regular().colorIconWarning,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                StyledText(
                  'no_internet_connection'.tr(),
                  fontSize: 16,
                  fontWeight: 500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      duration: null, // Infinite duration - stays until manually dismissed
      backgroundColor: Colors.transparent,
      isDismissible: false,
    );

    Get.showSnackbar(_stickyNetworkToast!);
  }
}
