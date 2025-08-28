import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/generated/codegen_loader.g.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;

class RewardTabContent extends StatefulWidget {
  const RewardTabContent({super.key});

  @override
  State<RewardTabContent> createState() => _RewardTabContentState();
}

class _RewardTabContentState extends State<RewardTabContent> {
  final controller = Get.find<ArchiveController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchRewards(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.fetchRewards();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24.sp,
      ),
      child: Obx(
        () {
          if (controller.rewards.isEmpty && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.rewards.isEmpty) {
            return Column(
              children: [
                SizedBox(height: 24.sp),
                iconEmpty,
                SizedBox(height: 20.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.sp),
                  child: Text(
                    'no_treasure_was_collected_during_this_exercise'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                          color: AppColorData.regular().colorTextPrimary,
                        ),
                  ),
                ),
              ],
            );
          }

          return AlignedGridView.count(
            controller: _scrollController,
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.rewards.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.rewards.length) {
                return _RewardItem(controller.rewards[index]);
              } else {
                return Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink());
              }
            },
          );
        },
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem(this.reward);

  final TreasureModel reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgTertiary,
        borderRadius:
            BorderRadius.circular(AppDoubleData.regular().numberRadius12),
        border: Border.all(
          width: AppDoubleData.regular().numberStroke2,
          color: AppColorData.regular().colorBorderBlack,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 41.sp, vertical: 37.sp)
                .copyWith(
              bottom: 57.sp,
            ),
            child: SizedBox.square(
              dimension: 92.sp,
              child: reward.iconUrl == null
                  ? iconCoinTik24
                  : CachedNetworkImage(
                      imageUrl: reward.iconUrl!,
                      width: 92.sp,
                      height: 92.sp,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
              bottom: 18,
              top: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff222229),
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(AppDoubleData.regular().numberRadius12),
                bottomRight:
                    Radius.circular(AppDoubleData.regular().numberRadius12),
              ),
            ),
            child: Text(
              "${reward.amount} ${reward.treasureSymbol}",
              textAlign: TextAlign.center,
              style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
