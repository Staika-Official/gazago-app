
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gaza_go/platform/controllers/collection_controller.dart';
import 'package:gaza_go/platform/controllers/collection_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
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


  Widget renderCollectionDateStatus(date){
    DateTime targetTime = DateTime.parse(date);
    DateTime currentTime = DateTime.now();
    bool isExpired = currentTime.isAfter(targetTime);
    return Text(isExpired ? '종료' :'진행중',
        style: AppTextStyleData
            .regular()
            .koBodyMediumSm.copyWith(
            color: isExpired ? AppColorData
                .regular()
                .colorBgInteractivePrimaryDisabled : AppColorData
                .regular()
                .colorPointCyan,

        )
    );
  }

  String renderGatheringRewardName(data){

    switch(data.type){
      case 'ITEM':
        return data.item.name;
      case 'BADGE':
        return data.badgeComposeConfig.name;
      case 'TIK':
        return 'TIK';
      case 'STIK':
        return 'STIK';
      default:
        return '';
    }
  }

  Widget renderGatheringRewardImage(data){
    switch(data.type){
      case 'ITEM':
        if(data.item.imageUrl.contains('.svg')){
          return SvgPicture.network(
            data.item.imageUrl,
            width: 80.sp,
            height: 80.sp,
            placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
          );
        } else {
          return Image.network(
            data.item.imageUrl,
            width: 80.sp,
            height: 80.sp,
            colorBlendMode: BlendMode.modulate,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Icon(Icons.error);
            },
          );
        }

      case 'BADGE':
        if(data.badgeComposeConfig.imageUrl.contains('.svg')){
          return SvgPicture.network(
            data.badgeComposeConfig.imageUrl,
            width: 80.sp,
            height: 80.sp,
            placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
          );
        } else {
          return Image.network(
            data.badgeComposeConfig.imageUrl,
            width: 80.sp,
            height: 80.sp,
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
      default: return Container();
    }
  }

  List<dynamic> renderGatheringCollectionList(data){
    return data.map((item) {
      return Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: Column(
          children: [
            Column(
              children: [
              Text(
                renderGatheringRewardName(item),
                  style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),),
                Padding(
                  padding: EdgeInsets.only(top:2.0.sp),
                  child: Text(
                    '11/${formatDecimalPlaces(item.quantity, 0)}',
                    style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
                  ),
                )


              ],
            ),
            Stack(
                children: [
                  SizedBox(
                      width: 89.sp,
                      height: 89.sp,
                      child: Center(
                        child: SizedBox(
                          width: 58.sp,
                            height: 58.sp,
                            child: renderGatheringRewardImage(item)
                        ),
                      )
                  ),
                  CustomPaint(
                    size: Size(89.sp, 89.sp),
                    painter: GaugePainter(
                      percentage: 70,
                      fillColor: AppColorData.regular().colorPointCyan,
                      backgroundColor: AppColorData.regular().colorBgTertiary,
                      gaugeType: GaugeType.circular,
                    ),
                  ),
                ]
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget renderCollectionImage(gatheringReward){
    String imageUrl = '';
    if (gatheringReward.badgeComposeConfig != null) {
      imageUrl = gatheringReward.badgeComposeConfig.imageUrl;
    } else if (gatheringReward.item != null) {
      imageUrl = gatheringReward.item.imageUrl;
    }

    if(imageUrl.contains('.svg')){
      return SvgPicture.network(
        imageUrl,
        width: 148.sp,
        height: 148.sp,
        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
      );
    } else {
      return Image.network(
        imageUrl,
        width: 148.sp,
        height: 148.sp,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Icon(Icons.error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppColorData
                    .regular()
                    .colorBgPrimary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.0.sp, vertical: 16.sp),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                              controller.detailCollection.name,
                               style: AppTextStyleData
                                .regular()
                                .koHeadingMediumSm.copyWith(
                                color: AppColorData
                                    .regular()
                                    .colorTextPrimary,
                            ),
                          )
                      ),
                      if(controller.detailCollection.toDateTime != null)
                        Padding(
                          padding: EdgeInsets.only(top:6.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${formatDateUntilDay(controller.detailCollection.toDateTime)}까지',
                                style: AppTextStyleData
                                    .regular()
                                    .koBodyMediumMd.copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextTertiary,
                                ),
                              ),
                              Text(
                                ' · ',
                                style: AppTextStyleData
                                    .regular()
                                    .koBodyMediumMd.copyWith(
                                  color: AppColorData
                                      .regular()
                                      .colorTextSecondary,
                                ),
                              ),
                              renderCollectionDateStatus(controller.detailCollection.toDateTime)
                            ],

                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top:controller.detailCollection.toDateTime != null ? 12.0.sp : 36.sp),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColorData.regular().colorBgTertiary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppDoubleData.regular().numberRadius12),
                            ),

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              children: [
                                renderCollectionImage(controller.detailCollection.gatheringReward),
                                Padding(
                                  padding: EdgeInsets.only(top:9.0.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          controller.detailCollection.gatheringReward.item == null ? controller.detailCollection.gatheringReward.badgeComposeConfig!.name : controller.detailCollection.gatheringReward.item!.name,
                                        style: AppTextStyleData
                                            .regular()
                                            .koBodyMediumLg.copyWith(
                                          color: AppColorData
                                              .regular()
                                              .colorTextPrimary,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:3.0.sp),
                                        child: iconRightLinkArrow,
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:20.0.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomPaint(
                              size: Size(double.infinity, 16.sp),
                              painter: GaugePainter(
                                percentage: 70,
                                fillColor: AppColorData.regular().colorPointCyan,
                                backgroundColor: AppColorData.regular().colorBgTertiary
                              ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.sp),
                              child: Text(
                                '11 / ${controller.detailCollection.gatheringConditions.length}',
                                style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                                  height: 1,
                              ),
                              ),
                            )
                        ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:20.0.sp),
                        child: controller.detailCollection.alreadyIssued ? Container(
                            decoration: BoxDecoration(
                              color: AppColorData.regular().colorBgPrimary,
                              border: Border.all(
                                width: 2,
                                style: BorderStyle.solid,
                                color: AppColorData.regular().colorBorderInteractivePrimaryPressed,
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
                                      style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorBorderInteractivePrimaryPressed,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )) : InkWell(
                          onTap:() => controller.detailCollection.getAble == true ? null : null,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColorData.regular().colorBgPrimary,
                                border: Border.all(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: controller.detailCollection.getAble == true ? AppColorData.regular().colorBorderInteractivePrimary:  AppColorData.regular().colorBorderInteractivePrimaryDisabled,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.sp),
                                ),

                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 25.sp),
                                child: Text(
                                  '리워드 받기',
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                    color: controller.detailCollection.getAble == true ? AppColorData.regular().colorTextPrimary : AppColorData.regular().colorBorderInteractivePrimaryDisabled,
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
                        style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                          color: AppColorData.regular().colorTextPrimary,

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:4.0.sp),
                        child: Text(
                          '컬렉션 재료는 리워드를 받으면 사라져요.',
                          style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextSecondary,

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0.sp),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 0,
                          mainAxisSpacing:0,
                          crossAxisCount: 3,
                          childAspectRatio: 0.55,
                          children: [
                            ...renderGatheringCollectionList(controller.detailCollection.gatheringConditions),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  }
}
