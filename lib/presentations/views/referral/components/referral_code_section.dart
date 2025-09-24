import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ReferralCodeSection extends GetWidget<ReferralController> {
  const ReferralCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 166.h,
      child: Stack(
        children: [
          // Background image (bottom layer)
          Container(
            height: 166.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
              image: const DecorationImage(
                image: AssetImage('assets/images/common/bg_loading.png'),
                fit: BoxFit.cover,
                alignment: Alignment(0, -0.45),
                colorFilter: ColorFilter.mode(
                  Color(0xFF0EE6F3),
                  BlendMode.overlay,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: StyledText(
                'share_your_code_with_friends'.tr(),
                fontSize: 16,
                fontWeight: 600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
          // Foreground container (top layer)
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 53.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0EE6F3), // Cyan background
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
              ),
              child: Column(
                children: [
                  // Bottom section with referral code
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                'your_referral_code'.tr(),
                                fontSize: 14,
                                fontWeight: 500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(height: 24.h),
                              Obx(
                                () => StyledText(
                                  controller.myReferralCode.value,
                                  fontSize: 24,
                                  fontWeight: 700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Copy button
                        Obx(
                          () => Material(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.r),
                              onTap: controller.canCopyCode.isTrue
                                  ? controller.onCodeCopied
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.h,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.file_copy_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4.w),
                                    StyledText(
                                      controller.canCopyCode.isTrue
                                          ? 'copy'.tr()
                                          : 'copied'.tr(),
                                      fontSize: 14,
                                      fontWeight: 500,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Overlay cursor icon on top-right (topmost layer)
          Positioned(
            top: 18,
            right: 15,
            child: Image.asset(
              'assets/images/referral/ico_cursor.png',
              width: 41,
              height: 53,
            ),
          ),
          // Overlay left cursor icon on top-left (topmost layer)
          Positioned(
            top: 25,
            left: 25,
            child: Image.asset(
              'assets/images/referral/ico_cursor_left.png',
              width: 20,
              height: 23,
            ),
          ),
        ],
      ),
    );
  }
}
