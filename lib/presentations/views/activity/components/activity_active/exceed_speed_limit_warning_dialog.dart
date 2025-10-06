import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/context_helper.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;

class IsExceedSpeedLimitWarningDialog extends StatelessWidget {
  const IsExceedSpeedLimitWarningDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColorData.regular().colorBgTertiary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            iconErrorCircle24,
            const SizedBox(height: 8),
            Text(
              'you_are_moving_to_fast_please_slow_down'.tr(),
              style: AppTextStyleData.regular().koHeadingSemiboldSm.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'violating_exercise_fairness_will_be_penalized'.tr(),
              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GazagoButton(
              buttonColor: AppColorData.regular().colorBgInteractivePrimary,
              buttonText: 'confirm'.tr(),
              onTap: Get.back,
              disableButton:
                  Get.find<ActivityController>().pickupLoading.isTrue,
            ),
          ],
        ),
      ),
    );
  }
}
