import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

enum DialogType { success, failure }

class OverlayDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const OverlayDialog({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Main dialog container
          Container(
            width: 358.w,
            height: 256.h,
            margin: EdgeInsets.only(top: 66.h), // Half of icon height (132/2)
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: type == DialogType.success
                    ? [
                        const Color(0xFF087F86), // 0%
                        const Color(0xFF1E4A53), // 55.38%
                        const Color(0xFF363841), // 89.84%
                      ]
                    : [
                        const Color(0xFF720F0F), // -21.09%
                        const Color(0xFF3D2426), // 53.81%
                        const Color(0xFF363841), // 94.14%
                      ],
                stops: type == DialogType.success
                    ? [0.0, 0.5538, 0.8984]
                    : [0.0, 0.5381, 0.9414],
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 72.h,
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              child: Column(
                children: [
                  // Title
                  StyledText(
                    title,
                    fontSize: 20,
                    fontWeight: 600,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  // Description
                  StyledText(
                    description,
                    fontSize: 16,
                    fontWeight: 400,
                    color: Colors.white.withOpacity(0.8),
                    textAlign: TextAlign.center,
                    lineHeight: 20,
                  ),
                  SizedBox(height: 40.h), // Gap as specified
                  // Button
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: type == DialogType.success
                                ? const Color(0xFF0EE6F3)
                                : const Color(0xFF363841),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: onButtonPressed ?? () => Get.back(),
                              child: Center(
                                child: StyledText(
                                  buttonText,
                                  fontSize: 18,
                                  fontWeight: 600,
                                  color: type == DialogType.success
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Overlay icon positioned at the top
          Positioned(
            top: 0,
            child: Image.asset(
              type == DialogType.success
                  ? 'assets/images/referral/ico_dialog_success.png'
                  : 'assets/images/referral/ico_dialog_fail.png',
              height: 132.h,
            ),
          ),
        ],
      ),
    );
  }

  // Static methods for easy usage
  static Future<T?> showSuccess<T>({
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Get.dialog<T>(
      OverlayDialog(
        type: DialogType.success,
        title: title,
        description: description,
        buttonText: buttonText ?? 'awesome'.tr(),
        onButtonPressed: onButtonPressed,
      ),
      barrierDismissible: false,
    );
  }

  static Future<T?> showFailure<T>({
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Get.dialog<T>(
      OverlayDialog(
        type: DialogType.failure,
        title: title,
        description: description,
        buttonText: buttonText ?? 'close'.tr(),
        onButtonPressed: onButtonPressed,
      ),
      barrierDismissible: false,
    );
  }
}
