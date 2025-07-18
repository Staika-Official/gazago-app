import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/collection_detail_controller.dart';
import 'package:gaza_go/platform/controllers/collection_reward_detail_controller.dart';
import 'package:gaza_go/platform/controllers/shop_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class CollectionRewardDetail extends StatelessWidget {
  const CollectionRewardDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionRewardDetailController controller =
        Get.put(CollectionRewardDetailController());

    return Scaffold(
        appBar: const SecondaryAppbar(
          isShowBackButton: true,
          isShowPreferencesButton: false,
        ),
        backgroundColor: AppColorData.regular().colorBgPrimary,
        body: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0.sp, right: 16.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColorData.regular().colorBgTertiary,
                          border: Border.all(
                            width: 2.sp,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                AppDoubleData.regular().numberRadius12.sp),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4.sp),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          child: Stack(
                            children: [
                              if (controller.rewardItem.itemGrade != null &&
                                  controller.rewardItem.itemGrade != 'NONE')
                                Positioned(
                                  right: 32.sp,
                                  top: 0,
                                  child: getItemGradeIcon(
                                      controller.rewardItem.itemGrade!),
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.sp, vertical: 28.0.sp),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Stack(
                                            children: [
                                              if (controller
                                                      .rewardItem.publishType ==
                                                  'NFT')
                                                Positioned.fill(
                                                    left: 24.sp,
                                                    right: 24.sp,
                                                    child: SvgPicture.asset(
                                                        'assets/images/shop/ico_nft_detail.svg')),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.0.sp),
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 174.sp,
                                                    child: controller.rewardItem
                                                                    .imageUrl !=
                                                                null &&
                                                            controller
                                                                .rewardItem
                                                                .imageUrl!
                                                                .contains(
                                                                    '.svg')
                                                        ? SvgPicture.network(
                                                            fit: BoxFit.contain,
                                                            controller
                                                                .rewardItem
                                                                .imageUrl!,
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      30.0),
                                                              child: const CircularProgressIndicator(
                                                                  color:
                                                                      skyBlueColor),
                                                            ),
                                                            headers:
                                                                imageNetworkHeader,
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl: controller
                                                                .rewardItem
                                                                .imageUrl!,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child: SizedBox.square(
                                                                        dimension:
                                                                            40,
                                                                        child: CircularProgressIndicator(
                                                                            color:
                                                                                skyBlueColor))),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Center(
                                                                    child: SizedBox.square(
                                                                        dimension:
                                                                            40,
                                                                        child: CircularProgressIndicator(
                                                                            color:
                                                                                skyBlueColor))),
                                                            httpHeaders:
                                                                imageNetworkHeader,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.sp),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (controller
                                                  .rewardItem.publishType ==
                                              'NFT')
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5.0.sp, top: 2.8.sp),
                                              child: SvgPicture.asset(
                                                  'assets/images/shop/ico_nft_label.svg'),
                                            ),
                                          Text(
                                            controller.rewardItem.name,
                                            style: AppTextStyleData.regular()
                                                .koBodySemiboldXl
                                                .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 25.0.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'stats'.tr(),
                              style: AppTextStyleData.regular()
                                  .koBodySemiboldXl
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.0.sp),
                              child: InkWell(
                                onTap: () => showItemTipAlert(),
                                child: iconExclamationMarkSmall,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Go 보상
                      if (controller.rewardItem.maxGoProfit != null &&
                          controller.rewardItem.maxGoProfit! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatGo,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'go_accumulation'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.minGoProfit!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.maxGoProfit!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller.rewardItem
                                                          .maxGoProfit! /
                                                      controller.rewardItem
                                                          .minGoProfit!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointCyan,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointCyan
                                                    .withOpacity(.4),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 신발 내구도
                      if (controller.rewardItem.maxDurability != null &&
                          controller.rewardItem.maxDurability! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatDurability,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'durability_resistance'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller
                                                .rewardItem.minDurability!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPurple,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPurple,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller
                                                .rewardItem.maxDurability!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPurple,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller.rewardItem
                                                          .maxDurability! /
                                                      controller.rewardItem
                                                          .minDurability!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPurple,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPurple
                                                    .withOpacity(.4),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 체력
                      if (controller.rewardItem.maxStamina != null &&
                          controller.rewardItem.maxStamina! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatStamina,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'stamina_resistance'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.minStamina!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointYellowgreen,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointYellowgreen,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.maxStamina!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointYellowgreen,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller.rewardItem
                                                          .maxStamina! /
                                                      controller.rewardItem
                                                          .minStamina!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointYellowgreen,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointYellowgreen
                                                    .withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 행운
                      if (controller.rewardItem.maxLuck != null &&
                          controller.rewardItem.maxLuck! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatLuck,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'luck'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.minLuck!, 0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.maxLuck!, 0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller
                                                          .rewardItem.maxLuck! /
                                                      controller
                                                          .rewardItem.minLuck!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPink,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPink
                                                    .withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (controller.rewardItem.rewardRateTo != null &&
                          controller.rewardItem.rewardRateTo! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatGo,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'go_accumulation'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller
                                                .rewardItem.rewardRateFrom!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.rewardRateTo!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointCyan,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller.rewardItem
                                                          .rewardRateTo! /
                                                      controller.rewardItem
                                                          .rewardRateFrom!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointCyan,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointCyan
                                                    .withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (controller.rewardItem.luckRateTo != null &&
                          controller.rewardItem.luckRateTo! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatLuck,
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: Text(
                                          'luck'.tr(),
                                          style: AppTextStyleData.regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                                  color: AppColorData.regular()
                                                      .colorTextPrimary,
                                                  height: 1.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.luckRateFrom!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                      Text(
                                        formatDecimalPlaces(
                                            controller.rewardItem.luckRateTo!,
                                            0),
                                        style: AppTextStyleData.regular()
                                            .koBodySemiboldMd
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorPointPink,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth /
                                                  (controller.rewardItem
                                                          .luckRateTo! /
                                                      controller.rewardItem
                                                          .luckRateFrom!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPink,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular()
                                                    .colorPointPink
                                                    .withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                      Padding(
                        padding: EdgeInsets.only(top: 24.sp, bottom: 82.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.sp),
                              child: Text(
                                'item_or_badge_description'.tr(args: [
                                  controller.rewardItem.type == 'ITEM'
                                      ? 'item'.tr()
                                      : 'badge'.tr()
                                ]),
                                style: AppTextStyleData.regular()
                                    .koBodySemiboldLg
                                    .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary,
                                    ),
                              ),
                            ),
                            Text(
                              controller.rewardItem.description.toString(),
                              style: AppTextStyleData.regular()
                                  .koBodyMediumMd
                                  .copyWith(
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
