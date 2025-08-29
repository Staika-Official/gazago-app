import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class CoolDownWidget extends GetWidget<ActivityController> {
  const CoolDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Obx(
        () => Visibility.maintain(
          visible: controller.coolDownTimeLeft.value > 0,
          child: BaseCard(
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 6.sp),
            borderRadius: AppDoubleData.regular().numberRadius12,
            backgroundColor: AppColorData.regular().colorBgInteractiveSecondary,
            child: Row(
              children: [
                iconSnowSharp,
                SizedBox(width: 6.sp),
                StyledText(
                  parseIntToHourMinute(
                    controller.coolDownTimeLeft.value,
                  ),
                  fontWeight: 700,
                  fontSize: 18,
                  color: AppColorData.regular().colorPointGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
