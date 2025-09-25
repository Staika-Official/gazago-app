import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/platform/services/referral_service.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/overlay_dialog.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class RedeemCodeButton extends GetWidget<ReferralController> {
  const RedeemCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide button if user has already redeemed a code (referredBy is not null)
      if (controller.referredBy.value != null) {
        return const SizedBox.shrink();
      }

      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(AppDoubleData.regular().numberSpacing12),
          side: BorderSide(
              width: 2,
              color: AppColorData.regular().colorBorderInteractiveSecondary),
        ),
        child: Text(
          'redeem_code'.tr(),
          style: AppTextStyleData.regular()
              .koBodyMediumXl
              .copyWith(color: Colors.white),
        ),
        onPressed: () {
          _showRedeemDialog();
        },
      );
    });
  }

  void _showRedeemDialog() {
    Get.bottomSheet(
      const RedeemCodeBottomSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      ignoreSafeArea: false,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class NoSpaceTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(' ', '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class RedeemCodeBottomSheet extends GetWidget<ReferralController> {
  const RedeemCodeBottomSheet({super.key});

  Future<void> _handleReferralCodeSubmission(
      String code,
      TextEditingController codeController,
      RxBool hasError,
      RxString errorMessage,
      RxBool isSubmitting) async {
    // Set loading state
    isSubmitting.value = true;

    try {
      // Call referral service directly with custom error handling
      await ReferralService.redeemReferralCode(
        controller.profile.value.id.toString(),
        code,
        successCallback: () {
          // Clear input and close dialog on success
          codeController.clear();
          Get.back();
          // Show success overlay dialog
          OverlayDialog.showSuccess(
            title: 'success'.tr(),
            description: 'success_redeemed_code'.tr(),
          );
          // Refresh referees list
          controller.refreshReferees();
        },
        errorCallback: (String errorMsg, bool isCodeNotFound) {
          if (isCodeNotFound) {
            // Show error in current dialog, don't close
            hasError.value = true;
            errorMessage.value = errorMsg;
          } else {
            // Close dialog and show overlay for other errors
            Get.back();
            OverlayDialog.showFailure(
              title: 'failed'.tr(),
              description: errorMsg,
            );
          }
        },
      );
    } finally {
      // Always reset loading state
      isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final RxString errorMessage = ''.obs;
    final RxBool hasError = false.obs;
    final RxBool hasText = false.obs;
    final RxBool isSubmitting = false.obs;

    return AnimatedPadding(
      padding: const EdgeInsets.only(bottom: 0),
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 440.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDoubleData.regular().numberRadius20),
            topRight: Radius.circular(AppDoubleData.regular().numberRadius20),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF087F86),
              Color(0xFF164048),
              Color(0xFF1D1D26),
            ],
            stops: [0.0, 0.2787, 0.5978],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(AppDoubleData.regular().numberRadius20),
                  topRight:
                      Radius.circular(AppDoubleData.regular().numberRadius20),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF087F86),
                    Color(0xFF1E4A53),
                    Color(0xFF363841),
                  ],
                  stops: [0.0, 0.3174, 0.7053],
                ),
              ),
            ),

            // Top illustration image
            Positioned(
              top: -74.h,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/referral/img_referral_dialog.png',
                  width: 248.w,
                  height: 128.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.only(
                top: 72.h,
                left: 16.w,
                right: 16.w,
                bottom: 36.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  StyledText(
                    'redeem_referral_code'.tr(),
                    fontSize: 20,
                    fontWeight: 600,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  // Subtitle
                  StyledText(
                    'enter_code_from_friend'.tr(),
                    fontSize: 14,
                    fontWeight: 500,
                    color: Colors.white.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 40.h),

                  // Input field
                  Obx(() => Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: subBg01Color,
                          borderRadius: BorderRadius.circular(8),
                          border: hasError.value
                              ? Border.all(
                                  color: dangerColor,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: codeController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLength: 8,
                                inputFormatters: [
                                  // Chỉ xóa khoảng trắng, không xóa tiếng Việt
                                  NoSpaceTextFormatter(),
                                  // Convert to uppercase automatically
                                  UpperCaseTextFormatter(),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'enter_8_char_code'.tr(),
                                  hintStyle: TextStyle(
                                    color: deepGrayColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  counterText: '', // Hide character counter
                                ),
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  hasText.value = value.isNotEmpty;

                                  // Clear error when user starts typing
                                  if (hasError.value) {
                                    hasError.value = false;
                                    errorMessage.value = '';
                                  }

                                  // Validate format immediately (exactly 8 characters)
                                  if (value.isNotEmpty) {
                                    // Không cần trim vì spaces đã bị xóa bởi input formatter
                                    if (value.length != 8) {
                                      hasError.value = true;
                                      errorMessage.value =
                                          'code_must_be_8_characters'.tr();
                                    } else {
                                      // Chấp nhận tất cả ký tự (bao gồm tiếng Việt), chỉ kiểm tra độ dài
                                      hasError.value = false;
                                      errorMessage.value = '';
                                    }
                                  }
                                },
                              ),
                            ),
                            // Clear button
                            if (hasText.value)
                              GestureDetector(
                                onTap: () {
                                  codeController.clear();
                                  hasText.value = false;
                                  hasError.value = false;
                                  errorMessage.value = '';
                                },
                                child: Icon(
                                  Icons.close,
                                  color: hasError.value
                                      ? dangerColor
                                      : deepGrayColor,
                                  size: 20.sp,
                                ),
                              ),
                          ],
                        ),
                      )),

                  // Error message
                  Obx(() => errorMessage.value.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 8.h),
                          padding: EdgeInsets.all(8.w),
                          alignment: Alignment.centerLeft,
                          child: StyledText(
                            errorMessage.value,
                            fontSize: 12,
                            fontWeight: 500,
                            color: dangerColor,
                            textAlign: TextAlign.left,
                          ),
                        )
                      : const SizedBox.shrink()),

                  const SizedBox(height: 40),

                  // Buttons
                  Column(
                    children: [
                      // Submit button
                      Obx(() {
                        final canSubmit = hasText.value &&
                            !hasError.value &&
                            !isSubmitting.value;
                        return Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: canSubmit ? skyBlueColor : deepGrayColor,
                            border: Border.all(
                              width: 2.sp,
                              color: Colors.black,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.sp),
                            child: InkWell(
                              onTap: canSubmit
                                  ? () async {
                                      // No need to trim or convert to uppercase since input formatters handle this
                                      final code = codeController.text;

                                      // Basic validation
                                      if (code.isEmpty) {
                                        hasError.value = true;
                                        errorMessage.value =
                                            'please_enter_referral_code'.tr();
                                        return;
                                      }

                                      // Validate exactly 8 characters
                                      if (code.length != 8) {
                                        hasError.value = true;
                                        errorMessage.value =
                                            'code_must_be_exactly_8_characters'
                                                .tr();
                                        return;
                                      }

                                      // Chỉ kiểm tra độ dài, chấp nhận tất cả ký tự (bao gồm tiếng Việt)
                                      // Không cần regex strict nữa

                                      // Call API for all codes (no more mock/test cases)
                                      await _handleReferralCodeSubmission(
                                          code,
                                          codeController,
                                          hasError,
                                          errorMessage,
                                          isSubmitting);
                                    }
                                  : null,
                              borderRadius: BorderRadius.circular(8.sp),
                              child: Center(
                                child: isSubmitting.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : StyledText(
                                        'submit'.tr(),
                                        fontSize: 18,
                                        lineHeight: 18,
                                        fontWeight: 500,
                                        color: Colors.black,
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      // Cancel button
                      GazagoButton(
                        borderColor: Colors.black,
                        buttonText: 'cancel'.tr(),
                        buttonColor: Colors.transparent,
                        textColor: Colors.white,
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
