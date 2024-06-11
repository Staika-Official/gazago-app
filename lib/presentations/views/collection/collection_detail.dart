import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/constants/routes.dart';

import 'package:gaza_go/platform/controllers/collection_controller.dart';
import 'package:gaza_go/platform/controllers/collection_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/gauge_painter.dart';

import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';

import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';


class CollectionDetail extends StatelessWidget {
  const CollectionDetail({super.key});

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  Widget renderCollectionDateStatus(date) {
    DateTime targetTime = DateTime.parse(date);
    DateTime currentTime = DateTime.now();
    bool isExpired = currentTime.isAfter(targetTime);
    return Text(isExpired ? '종료' : '진행중',
        style: AppTextStyleData
            .regular()
            .koBodyMediumSm
            .copyWith(
          color: isExpired ? AppColorData
              .regular()
              .colorBgInteractivePrimaryDisabled : AppColorData
              .regular()
              .colorPointCyan,

        )
    );
  }

  String renderGatheringRewardName(data) {
    switch (data.type) {
      case 'ITEM':
        return data.item.name;
      case 'BADGE':
        return data.badgeComposeConfig.name;
      case 'TIK':
        return 'TIK';
      case 'STIK':
        return 'STIK';
      case 'PTIK':
        return 'TIK';
      default:
        return '';
    }
  }

  Widget renderGatheringRewardImage(data) {
    switch (data.type) {
      case 'ITEM':
        if (data.item.imageUrl.contains('.svg')) {
          return SvgPicture.network(
            data.item.imageUrl,
            width: 60.sp,
            height: 60.sp,
            placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
          );
        } else {
          return Image.network(
            data.item.imageUrl,
            width: 60.sp,
            height: 60.sp,
            colorBlendMode: BlendMode.modulate,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Icon(Icons.error);
            },
          );
        }

      case 'BADGE':
        if (data.badgeComposeConfig.imageUrl.contains('.svg')) {
          return SvgPicture.network(
            data.badgeComposeConfig.imageUrl,
            width: 60.sp,
            height: 60.sp,
            placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
          );
        } else {
          return Image.network(
            data.badgeComposeConfig.imageUrl,
            width: 60.sp,
            height: 60.sp,
            colorBlendMode: BlendMode.modulate,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Icon(Icons.error);
            },
          );
        }
      case 'TIK':
        return SvgPicture.asset(
          'assets/images/common/ico_collection_reward_tik.svg',
          width: 44.sp,
          height: 44.sp,
        );
      case 'STIK':
        return SvgPicture.asset(
          'assets/images/common/ico_collection_reward_stik.svg',
          width: 44.sp,
          height: 44.sp,
        );
      case 'PTIK':
        return SvgPicture.asset(
          'assets/images/common/ico_collection_reward_tik.svg',
          width: 44.sp,
          height: 44.sp,
        );
      default:
        return Container();
    }
  }

  List<dynamic> renderGatheringCollectionList(CollectionDetailController controller, data, context) {
    return data.map((item) {
      return Padding(
        padding: EdgeInsets.all(0.0.sp),
        child: Container(
          width: (MediaQuery
              .of(context)
              .size
              .width / 3) - 17.sp,
          height: 180.sp,
          decoration: BoxDecoration(
            color: AppColorData
                .regular()
                .colorBgPrimary,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDoubleData
                  .regular()
                  .numberRadius12),
            ),

          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 12.sp),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 38.sp,
                      child: Center(
                        child: Text(
                          renderGatheringRewardName(item),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          style: AppTextStyleData
                              .regular()
                              .koBodyMediumMd
                              .copyWith(
                              color: AppColorData
                                  .regular()
                                  .colorTextPrimary,
                              height: 1.2
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ),
                    ),
                    controller.detailCollection.value.toDateTime != null && controller.checkCollectionExpired(controller.detailCollection.value.toDateTime) ?
                    Text('완료', style: AppTextStyleData
                        .regular()
                        .koBodyMediumSm
                        .copyWith(
                      color: AppColorData
                          .regular()
                          .colorTextBrand,

                    ),) :
                    item.type == 'ITEM' || item.type == 'BADGE' ?
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.sp),
                      child: FittedBox(
                        child: Text(
                          '${item.completeAmount ?? 0} / ${formatDecimalPlaces(item.quantity, 0)}',
                          style: AppTextStyleData
                              .regular()
                              .koBodyMediumSm
                              .copyWith(
                            color: AppColorData
                                .regular()
                                .colorTextPrimary,
                          ),
                        ),
                      ),
                    ) : Padding(
                      padding: EdgeInsets.only(top: 2.0.sp),
                      child: FittedBox(
                        child: Text(
                          '${formatDecimalPlaces(controller.currentMyTokenCondition(item.type), 2, isAutoDecimal: true)} / ${formatDecimalPlaces(item.quantity, 2, isAutoDecimal: true)}',
                          style: AppTextStyleData
                              .regular()
                              .koBodyMediumSm
                              .copyWith(
                            color: AppColorData
                                .regular()
                                .colorTextPrimary,
                          ),
                        ),
                      ),
                    ),
                    // StyledText(item.percentage.toString()),

                    //         : Text('완료', style: AppTextStyleData
                    //     .regular()
                    //     .koBodyMediumSm
                    //     .copyWith(
                    //   color: AppColorData
                    //       .regular()
                    //       .colorTextBrand,
                    //
                    // ),)
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                        children: [
                          if(item.completeAmount != null)
                            SizedBox(
                                width: 89.sp,
                                height: 89.sp,
                                child: Center(
                                  child: item.type == 'ITEM' || item.type == 'BADGE' ? Opacity(
                                      opacity: controller.detailCollection.value.alreadyIssued ? 1 : item.completeAmount / item.quantity >= 1 ? 1 : 0.5,
                                      child: renderGatheringRewardImage(item)
                                  ) : Opacity(
                                      opacity: controller.imageConditions(item.type, item.quantity) ? 1 : 0.5,
                                      child: renderGatheringRewardImage(item)
                                  ),
                                )
                            ),
                          item.type == 'ITEM' || item.type == 'BADGE' ? CustomPaint(
                            size: Size(89.sp, 89.sp),
                            painter: GaugePainter(
                              percentage: controller.detailCollection.value.alreadyIssued ? 100 : item.completeAmount != null ? (item.completeAmount / item.quantity) * 100 : 0,
                              fillColor: AppColorData
                                  .regular()
                                  .colorPointCyan,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorBgTertiary,
                              gaugeType: GaugeType.circular,
                            ),
                          ) : CustomPaint(
                            size: Size(89.sp, 89.sp),
                            painter: GaugePainter(
                              percentage: controller.currentMyTokenConditionPercentage(item.type, item.quantity),
                              fillColor: AppColorData
                                  .regular()
                                  .colorPointCyan,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorBgTertiary,
                              gaugeType: GaugeType.circular,
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    CollectionController collectionController = Get.find();
    CollectionDetailController controller = Get.put(CollectionDetailController());


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: preferredSize, // here the desired height
          child: const SecondaryAppbar(
            isShowBackButton: true,
            isShowPreferencesButton: false,
          )),
      backgroundColor: AppColorData
          .regular()
          .colorBgPrimary,
      body:
      SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              Container(
                color: AppColorData
                    .regular()
                    .colorBgPrimary,
                child: Padding(
                  padding: EdgeInsets.only(left: 37.0.sp, right: 37.0.sp, top: 16.sp, bottom: 24.sp),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                            controller.detailCollection.value.name,
                            style: AppTextStyleData
                                .regular()
                                .koHeadingMediumSm
                                .copyWith(
                              color: AppColorData
                                  .regular()
                                  .colorTextPrimary,
                            ),
                          )
                      ),
                      if(controller.detailCollection.value.toDateTime != null)
                        Padding(
                          padding: EdgeInsets.only(top: 6.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${formatDateUntilDay(controller.detailCollection.value.toDateTime)}까지',
                                style: AppTextStyleData
                                    .regular()
                                    .koBodyMediumMd
                                    .copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextTertiary,
                                ),
                              ),
                              Text(
                                ' · ',
                                style: AppTextStyleData
                                    .regular()
                                    .koBodyMediumMd
                                    .copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextSecondary,
                                ),
                              ),
                              renderCollectionDateStatus(controller.detailCollection.value.toDateTime)
                            ],

                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: controller.detailCollection.value.toDateTime != null ? 12.0.sp : 36.sp),
                        child: InkWell(
                          onTap: () =>
                          controller.detailCollection.value.gatheringReward.type == 'ITEM' || controller.detailCollection.value.gatheringReward.type == 'BADGE' ? Get.toNamed(
                              Routes.collectionRewardDetail, arguments: {'item': controller.detailCollection.value.gatheringReward}) : null,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColorData
                                  .regular()
                                  .colorBgTertiary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDoubleData
                                    .regular()
                                    .numberRadius12),
                              ),

                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0.sp),
                              child: Column(
                                children: [
                                  controller.renderCollectionImage(controller.detailCollection.value.gatheringReward),
                                  Padding(
                                    padding: EdgeInsets.only(top: 9.0.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        controller.detailCollection.value.gatheringReward.type == 'ITEM' || controller.detailCollection.value.gatheringReward == 'BADGE' ?
                                        Text(
                                          controller.detailCollection.value.gatheringReward.item == null ? controller.detailCollection.value.gatheringReward.badgeComposeConfig!.name : controller
                                              .detailCollection.value
                                              .gatheringReward.item!.name,
                                          style: AppTextStyleData
                                              .regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                            color: AppColorData
                                                .regular()
                                                .colorTextPrimary,
                                          ),
                                        ) :
                                        Text(
                                          '${formatDecimalPlaces(controller.detailCollection.value.gatheringReward.quantity, 0)} ${controller.detailCollection.value.gatheringReward.type}',
                                          style: AppTextStyleData
                                              .regular()
                                              .koBodyMediumLg
                                              .copyWith(
                                            color: AppColorData
                                                .regular()
                                                .colorTextPrimary,
                                          ),
                                        ),
                                        controller.detailCollection.value.gatheringReward.type == 'ITEM' || controller.detailCollection.value.gatheringReward.type == 'BADGE' ? Padding(
                                          padding: EdgeInsets.only(top: 3.0.sp),
                                          child: iconRightLinkArrow,
                                        ) : Container(),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(controller.detailCollection.value.completeQuantity != null)
                        Padding(
                        padding: EdgeInsets.only(top: 20.0.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: CustomPaint(
                                size: Size(double.infinity, 16.sp),
                                painter: GaugePainter(
                                    percentage: controller.detailCollection.value.alreadyIssued ? 100 : (controller.detailCollection.value.completeQuantity! /
                                        controller.detailCollection.value.gatheringConditions.length) * 100,
                                    fillColor: AppColorData
                                        .regular()
                                        .colorPointCyan,
                                    backgroundColor: AppColorData
                                        .regular()
                                        .colorBgTertiary
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.sp),
                              child: Text(
                                '${controller.detailCollection.value.alreadyIssued ? controller.detailCollection.value.gatheringConditions.length : controller.detailCollection.value
                                    .completeQuantity} / ${controller.detailCollection.value.gatheringConditions.length}',
                                style: AppTextStyleData
                                    .regular()
                                    .enBodySemiboldMd
                                    .copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextPrimary,
                                  height: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0.sp),
                        child: controller.detailCollection.value.alreadyIssued ? Container(
                            decoration: BoxDecoration(
                              color: AppColorData
                                  .regular()
                                  .colorBgPrimary,
                              border: Border.all(
                                width: 2,
                                style: BorderStyle.solid,
                                color: AppColorData
                                    .regular()
                                    .colorBorderInteractivePrimaryPressed,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.sp),
                              ),

                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 22.sp),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconCheckGetAble,
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.6.sp),
                                    child: Text(
                                      '수집완료',
                                      style: AppTextStyleData
                                          .regular()
                                          .koBodyMediumXl
                                          .copyWith(
                                        color: AppColorData
                                            .regular()
                                            .colorBorderInteractivePrimaryPressed,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )) : InkWell(
                          onTap: () => controller.detailCollection.value.getAble == true ? showConfirmCollectionRewardAlert(controller) : null,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColorData
                                    .regular()
                                    .colorBgPrimary,
                                border: Border.all(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: controller.detailCollection.value.getAble == true ? AppColorData
                                      .regular()
                                      .colorBorderInteractivePrimary : AppColorData
                                      .regular()
                                      .colorBorderInteractivePrimaryDisabled,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.sp),
                                ),

                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
                                child: Text(
                                  '리워드 받기',
                                  style: AppTextStyleData
                                      .regular()
                                      .koBodyMediumXl
                                      .copyWith(
                                    color: controller.detailCollection.value.getAble == true ? AppColorData
                                        .regular()
                                        .colorTextPrimary : AppColorData
                                        .regular()
                                        .colorBorderInteractivePrimaryDisabled,
                                    height: 1.1,
                                  ),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColorData
                    .regular()
                    .colorBgTertiary,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0.sp, horizontal: 16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        '컬렉션 재료',
                        style: AppTextStyleData
                            .regular()
                            .koBodyMediumXl
                            .copyWith(
                          color: AppColorData
                              .regular()
                              .colorTextPrimary,

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0.sp),
                        child: Text(
                          '컬렉션 재료는 리워드를 받으면 사라져요.',
                          style: AppTextStyleData
                              .regular()
                              .koBodyMediumMd
                              .copyWith(
                            color: AppColorData
                                .regular()
                                .colorTextSecondary,

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.sp),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Wrap(
                                  spacing: 8.0.sp, // 수평 간격
                                  runSpacing: 8.0.sp, // 수직 간격
                                  runAlignment: WrapAlignment.spaceBetween,
                                  children: [...renderGatheringCollectionList(controller, controller.detailCollection.value.gatheringConditions, context)],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      )
      ,
    );
  }
}
