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

class PickUpTreasureBottomSheet extends StatefulWidget {
  const PickUpTreasureBottomSheet({
    super.key,
    this.onPickUp,
    required this.treasureModel,
  });

  final Function()? onPickUp;
  final TreasureModel treasureModel;

  @override
  State<PickUpTreasureBottomSheet> createState() =>
      PickUpTreasureBottomSheetState();
}

class PickUpTreasureBottomSheetState extends State<PickUpTreasureBottomSheet> {
  void closeBottomSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgTertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'you_can_collect_a_treasure'.tr(),
            style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SvgPicture.asset(
            widget.treasureModel.iconPathLocal,
            width: 153,
          ),
          const SizedBox(height: 24),
          if (widget.treasureModel.type != null)
            UnconstrainedBox(
              child: BaseCard(
                backgroundColor: AppColorData.regular().colorBgPrimary,
                borderRadius: 8,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text(
                  widget.treasureModel.type!.getTypeForBottomSheet(),
                  style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                        color: AppColorData.regular().colorPointCyan,
                      ),
                ),
              ),
            ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: GazagoButton(
                  buttonColor: Colors.transparent,
                  buttonText: 'cancel'.tr(),
                  textColor:
                      AppColorData.regular().colorTextInteractiveSecondary,
                  onTap: Get.back,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => GazagoButton(
                    buttonColor:
                        AppColorData.regular().colorBgInteractivePrimary,
                    buttonText: 'collect'.tr(),
                    onTap: widget.onPickUp,
                    disableButton:
                        Get.find<ActivityController>().pickupLoading.isTrue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.getBottomPadding),
        ],
      ),
    );
  }
}
