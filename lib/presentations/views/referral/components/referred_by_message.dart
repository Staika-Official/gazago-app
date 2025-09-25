import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ReferredByMessage extends GetWidget<ReferralController> {
  const ReferredByMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only show if referredBy is not null
      if (controller.referredBy.value == null) {
        return const SizedBox.shrink();
      }

      return Text(
        'referred_by'.tr(namedArgs: {'username': controller.referredBy.value!}),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 1.4, // 140% line height
          letterSpacing: 0,
          color: Colors.white,
        ),
      );
    });
  }
}
