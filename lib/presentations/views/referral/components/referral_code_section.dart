import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;

class ReferralCodeSection extends GetWidget<ReferralController> {
  const ReferralCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: EdgeInsets.all(20.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  'your_referral_code'.tr(),
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => StyledText(
                    controller.myReferralCode.value,
                    fontSize: 24,
                    fontWeight: 700,
                  ),
                ),
              ],
            ),
          ),

          /// copy button
          Obx(
            () => Material(
              color: controller.canCopyCode.isTrue
                  ? buttonBgBlue
                  : buttonBgBlue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: controller.canCopyCode.isTrue
                    ? controller.onCodeCopied
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 8.h,
                  ),
                  child: StyledText(
                    controller.canCopyCode.isTrue ? 'copy'.tr() : 'copied'.tr(),
                    fontSize: 14,
                    color: controller.canCopyCode.isTrue
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
