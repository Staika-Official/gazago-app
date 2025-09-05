import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/helpers/context_helper.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/rotating_widget.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class PickUpTreasureResultOverlay extends StatelessWidget {
  const PickUpTreasureResultOverlay({
    super.key,
    required this.treasureModel,
  });

  final TreasureModel treasureModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (treasureModel.amount == 0) ...[
            iconRewardEmpty,
            const SizedBox(height: 16),
            BaseCard(
              backgroundColor: AppColorData.regular().colorBgPrimary,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text(
                'no_reward'.tr(),
                style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                      color: AppColorData.regular().colorPointCyan,
                    ),
              ),
            ),
          ] else ...[
            _AvailableTreasureIcon(treasureModel.iconUrl),
            BaseCard(
              backgroundColor: AppColorData.regular().colorBgPrimary,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text(
                'you_have_collected_x_symbol'.tr(args: [
                  treasureModel.amount.toString(),
                  treasureModel.treasureSymbol ?? '',
                ]),
                style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                      color: AppColorData.regular().colorPointPink,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC9C5C6),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.close, // X icon
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableTreasureIcon extends StatefulWidget {
  const _AvailableTreasureIcon(this.iconUrl);

  final String? iconUrl;

  @override
  State<_AvailableTreasureIcon> createState() => _AvailableTreasureIconState();
}

class _AvailableTreasureIconState extends State<_AvailableTreasureIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Lottie.asset(
            'assets/lottie/fireworks.json',
            repeat: true,
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: const Color(0xfffff2d9cc).withOpacity(0.8),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        RotatingWidget(
          child: circleAnimBg,
        ),
        if (widget.iconUrl != null)
          CachedNetworkImage(imageUrl: widget.iconUrl!)
        else
          iconCoinTik24,
      ],
    );
  }
}
