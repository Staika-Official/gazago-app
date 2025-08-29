import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;

class CoolDownWidgetMap extends GetWidget<ActivityController> {
  const CoolDownWidgetMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: UnconstrainedBox(
        child: Obx(
          () => Visibility.maintain(
            visible: controller.coolDownTimeLeft.value > 0,
            child: SizedBox(
              width: 200,
              child: BaseCard(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                borderRadius: AppDoubleData.regular().numberRadiusCircle,
                backgroundColor: AppColorData.regular().colorBgBrand,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 32,
                      child: iconClock,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${'next_treasure_pickup_available_in'.tr()} ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: parseIntToHourMinute(
                                controller.coolDownTimeLeft.value,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
