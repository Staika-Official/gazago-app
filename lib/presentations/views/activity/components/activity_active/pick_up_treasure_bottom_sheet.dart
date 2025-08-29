import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/helpers/context_helper.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;

class PickUpTreasureBottomSheet extends StatelessWidget {
  const PickUpTreasureBottomSheet({
    super.key,
    this.onPickUp,
    required this.treasureModel,
  });

  final Function()? onPickUp;
  final TreasureModel treasureModel;

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
          treasureModel.iconUrl.isNullOrBlank == true
              ? iconCoinTik24
              : Image.network(
                  treasureModel.iconUrl!,
                  width: 128,
                  height: 128,
                ),
          const SizedBox(height: 24),
          UnconstrainedBox(
            child: BaseCard(
              backgroundColor: AppColorData.regular().colorBgPrimary,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text(
                "${treasureModel.amount} ${treasureModel.treasureSymbol}",
                style: AppTextStyleData.regular().koBodySemiboldLg.copyWith(
                      color: AppColorData.regular().colorPointPink,
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
                child: GazagoButton(
                  buttonColor: AppColorData.regular().colorBgInteractivePrimary,
                  buttonText: 'collect'.tr(),
                  onTap: () {
                    Get.back();
                    onPickUp?.call();
                  },
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
