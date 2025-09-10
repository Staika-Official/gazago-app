import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
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

class RedeemCodeBottomSheet extends GetWidget<ReferralController> {
  const RedeemCodeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final RxString errorMessage = ''.obs;
    final RxBool hasError = false.obs;
    final RxBool hasText = false.obs;

    return AnimatedPadding(
      padding: const EdgeInsets.only(bottom: 0),
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 420.h,
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
                                textCapitalization:
                                    TextCapitalization.characters,
                                onChanged: (value) {
                                  hasText.value = value.isNotEmpty;

                                  // Clear error when user starts typing
                                  if (hasError.value) {
                                    hasError.value = false;
                                    errorMessage.value = '';
                                  }

                                  // Validate length immediately (8 characters as per spec)
                                  if (value.length != 8 && value.isNotEmpty) {
                                    hasError.value = true;
                                    errorMessage.value =
                                        'code_must_be_8_characters'.tr();
                                  } else if (value.length == 8) {
                                    hasError.value = false;
                                    errorMessage.value = '';
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
                        final canSubmit = hasText.value && !hasError.value;
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
                                      final code = codeController.text
                                          .trim()
                                          .toUpperCase();
                                      if (code.isEmpty) {
                                        hasError.value = true;
                                        errorMessage.value =
                                            'please_enter_referral_code'.tr();
                                        return;
                                      }

                                      if (code.length != 8) {
                                        hasError.value = true;
                                        errorMessage.value =
                                            'code_must_be_exactly_8_characters'
                                                .tr();
                                        return;
                                      }

                                      // Validate format: uppercase alphanumeric only
                                      final regex = RegExp(r'^[A-Z0-9]{8}$');
                                      if (!regex.hasMatch(code)) {
                                        hasError.value = true;
                                        errorMessage.value =
                                            'invalid_code_format'.tr();
                                        return;
                                      }

                                      // Close bottom sheet first
                                      Get.back();

                                      // Check for test codes (8-character format)
                                      if (code == 'ABCD1234') {
                                        // Show success dialog
                                        OverlayDialog.showSuccess(
                                          title: 'success'.tr(),
                                          description:
                                              'success_redeemed_code'.tr(),
                                        );
                                      } else if (code == 'TEST2025') {
                                        // Show success dialog
                                        OverlayDialog.showSuccess(
                                          title: 'success'.tr(),
                                          description:
                                              'referral_code_redeemed_successfully'
                                                  .tr(),
                                        );
                                      } else if (code == 'EXPIRED1') {
                                        // Show failure dialog
                                        OverlayDialog.showFailure(
                                          title: 'failed'.tr(),
                                          description:
                                              'referral_code_reached_limit'
                                                  .tr(),
                                        );
                                      } else {
                                        // For other codes, use the original controller logic
                                        try {
                                          final success = await controller
                                              .redeemReferralCode(code);

                                          if (success) {
                                            // Show success dialog
                                            OverlayDialog.showSuccess(
                                              title: 'success'.tr(),
                                              description:
                                                  'referral_code_redeemed_successfully'
                                                      .tr(),
                                            );
                                          } else {
                                            // Show failure dialog
                                            OverlayDialog.showFailure(
                                              title: 'failed'.tr(),
                                              description:
                                                  'invalid_referral_code_try_again'
                                                      .tr(),
                                            );
                                          }
                                        } catch (e) {
                                          // Show failure dialog for errors
                                          OverlayDialog.showFailure(
                                            title: 'failed'.tr(),
                                            description:
                                                'error_occurred_try_again'.tr(),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              borderRadius: BorderRadius.circular(8.sp),
                              child: Center(
                                child: StyledText(
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
