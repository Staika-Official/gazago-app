import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;

class redeem_codeButton extends GetWidget<ReferralController> {
  const redeem_codeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        side: const BorderSide(
          color: buttonBgBlue,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
      onPressed: () {
        //TODO: show redeem dialog here
      },
      child: StyledText(
        'redeem_code'.tr(),
        fontSize: 14,
        fontWeight: 500,
        color: buttonBgBlue,
      ),
    );
  }
}
