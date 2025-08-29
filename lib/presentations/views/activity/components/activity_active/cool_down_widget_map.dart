import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class CoolDownWidgetMap extends GetWidget<ActivityController> {
  const CoolDownWidgetMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: UnconstrainedBox(
        child: Obx(
          () => Visibility(
            visible: controller.coolDownTimeLeft.value > 0,
            child: BaseCard(
              padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 10.sp),
              borderRadius: AppDoubleData.regular().numberRadius12,
              backgroundColor:
                  AppColorData.regular().colorBgInteractiveSecondary,
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: iconSnowSharp,
                  ),
                  SizedBox(width: 6.sp),
                  StyledText(
                    parseIntToHourMinute(
                      controller.coolDownTimeLeft.value,
                    ),
                    fontWeight: 700,
                    fontSize: 24,
                    color: AppColorData.regular().colorPointGreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
