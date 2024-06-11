import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/collection_controller.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/gauge_painter.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class CollectionHome extends StatelessWidget {
  const CollectionHome({super.key});

  Widget renderCollectionDdayLabel(String date) {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime.parse(date);
    Duration diff = endDate.difference(now);
    return Container(
      decoration: BoxDecoration(
        color: diff < Duration(days: 1) ? AppColorData
            .regular()
            .colorBgWarningSubtle : AppColorData
            .regular()
            .colorPointBrandgray,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDoubleData
              .regular()
              .numberRadius4),
        ),

      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0.sp, bottom: 1.sp, left: 4.sp, right: 4.sp),
        child: Text(
          diff.inDays < 0 ? 'D+${diff.inDays.abs()}' : 'D-${diff.inDays}',
          style: AppTextStyleData
              .regular()
              .koCaptionSemiboldMd
              .copyWith(
            color: AppColorData
                .regular()
                .colorTextInverse,
          ),
        ),
      ),
    );
  }

  List<Widget> renderDifficultyStar(String gatheringDifficultyType) {
    print(gatheringDifficultyType);
    int difficulty = int.parse(gatheringDifficultyType.split('_')[1]);
    List<Widget> stars = [];
    for (int i = 0; i < difficulty; i++) {
      stars.add(SvgPicture.asset('assets/images/common/ico_difficult_star.svg', color: renderDifficultyColor(gatheringDifficultyType),));
    }
    return stars;
  }

  Widget renderCollectionDifficultyGrade(String gatheringDifficultyType) {
    return Container(
        decoration: BoxDecoration(
          color: AppColorData
              .regular()
              .colorBgPrimary,
          border: Border.all(
            width: 2.sp,
            color: renderDifficultyColor(gatheringDifficultyType),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDoubleData
                .regular()
                .numberRadius4),
          ),

        ),
        child: Padding(
          padding: EdgeInsets.only(left: 8.0.sp, right: 8.0.sp, top: 2.0.sp, bottom: 2.0.sp),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 3.0.sp),
                child: Text(
                  renderDifficultyText(gatheringDifficultyType),
                  style: AppTextStyleData
                      .regular()
                      .koCaptionSemiboldMd
                      .copyWith(
                    color: renderDifficultyColor(gatheringDifficultyType),
                  ),
                ),
              ),
              ...renderDifficultyStar(gatheringDifficultyType),
            ],
          ),
        )
    );
  }

  List<dynamic> renderCollectionList(CollectionController controller, data) {
    return data.map((item) {
      return InkWell(
        onTap: () {
          controller.moveToDetailCollection(item);
        },
        child: Padding(
          padding: EdgeInsets.all(12.0.sp),
          child: Column(
            children: [
              renderCollectionDifficultyGrade(item.gatheringDifficultyType),
              Stack(
                  children: [
                    SizedBox(
                        width: 114.sp,
                        height: 114.sp,
                        child: Center(
                            child: item.gatheringConditions == item.completeQuantity || item.alreadyIssued
                                ? renderCollectionImage(item.gatheringReward)
                                : ColorFiltered(
                                colorFilter: const ColorFilter.matrix(<double>[
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: renderCollectionImage(item.gatheringReward)
                            )
                        )
                    ),
                    if(item.toDateTime != null)
                      Positioned(left: 0, top: 2.sp, child: renderCollectionDdayLabel(item.toDateTime)),
                  ]
              ),
              item.alreadyIssued ? Padding(
                padding: EdgeInsets.only(top: 4.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCollectionComplete,
                    Padding(
                      padding: EdgeInsets.only(left: 3.0.sp),
                      child: Text(
                        '컬렉션 완료',
                        style: AppTextStyleData
                            .regular()
                            .koBodyMediumSm
                            .copyWith(
                            color: AppColorData
                                .regular()
                                .colorTextPrimary,
                            height: 1.1
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Column(
                children: [
                  CustomPaint(
                    size: Size(double.infinity, 8.sp),
                    painter: GaugePainter(
                        percentage: item.completeQuantity != null ? (item.completeQuantity / item.gatheringConditions.length) * 100 : 0,
                        fillColor: AppColorData
                            .regular()
                            .colorPointCyan,
                        backgroundColor: AppColorData
                            .regular()
                            .colorBgTertiary
                    ),
                  ),
                  if(item.completeQuantity != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.sp),
                      child: item.completeQuantity == item.gatheringConditions.length ? Text(
                        '리워드 받기!',
                        style: AppTextStyleData
                            .regular()
                            .koBodyMediumSm
                            .copyWith(
                            color: AppColorData
                                .regular()
                                .colorTextPrimary,
                            height: 1.5
                        ),
                      ) : Text(
                        '${item.completeQuantity != null ? item.completeQuantity : 0}/${item.gatheringConditions.length}',
                        style: AppTextStyleData
                            .regular()
                            .koBodyMediumSm
                            .copyWith(
                          color: AppColorData
                              .regular()
                              .colorTextPrimary,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget renderCollectionImage(gatheringReward) {
    String imageUrl = '';
    if (gatheringReward.type == 'BADGE' || gatheringReward.type == 'ITEM') {
      if (gatheringReward.badgeComposeConfig != null) {
        imageUrl = gatheringReward.badgeComposeConfig.imageUrl;
      } else if (gatheringReward.item != null) {
        imageUrl = gatheringReward.item.imageUrl;
      }

      if (imageUrl.contains('.svg')) {
        return SvgPicture.network(
          imageUrl,
          width: 100.sp,
          height: 100.sp,
          placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
        );
      } else {
        return Image.network(
          imageUrl,
          width: 100.sp,
          height: 100.sp,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        );
      }
    } else {
      if (gatheringReward.type == 'TIK' || gatheringReward.type == 'PTIK') {
        return SvgPicture.asset('assets/images/collection/ico_collection_token_tik.svg', width: 100.sp, height: 100.sp);
      } else {
        return SvgPicture.asset('assets/images/collection/ico_collection_token_stik.svg', width: 100.sp, height: 100.sp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionController controller = Get.find();

    return DefaultContainer(
      // titleText: controller.selectedItem.value.itemName,
      titleWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledText(
            '컬렉션',
            fontSize: 18,
            lineHeight: 20,
            fontWeight: 500,
            letterSpacing: -0.02,
          ),
        ],
      ),
      backgroundColor: AppColorData
          .regular()
          .colorBgPrimary,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.fixedCollection.value.id != 0 ?
                      InkWell(
                      onTap: () {
                        controller.moveToDetailCollection(controller.fixedCollection.value);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.sp, right: 16.0.sp, top: 12.sp, bottom: 16.0.sp),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColorData
                                .regular()
                                .colorBgTertiary,
                            border: Border.all(
                              width: 2.sp,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppDoubleData
                                  .regular()
                                  .numberRadius12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 3.sp),
                                blurRadius: 0.0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0.sp),
                            child: Row(
                              children: [
                                Container(
                                  width: 116.sp,
                                  height: 116.sp,
                                  decoration: BoxDecoration(
                                    color: AppColorData
                                        .regular()
                                        .colorBgPrimary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDoubleData
                                          .regular()
                                          .numberRadius8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0.sp),
                                    child:
                                        controller.fixedCollection.value.completeQuantity == controller.fixedCollection.value.gatheringConditions.length
                                        ? renderCollectionImage(controller.fixedCollection.value.gatheringReward)
                                        : ColorFiltered(
                                        colorFilter: ColorFilter.matrix(<double>[
                                          0.2126, 0.7152, 0.0722, 0, 0,
                                          0.2126, 0.7152, 0.0722, 0, 0,
                                          0.2126, 0.7152, 0.0722, 0, 0,
                                          0, 0, 0, 1, 0,
                                        ]),
                                        child: renderCollectionImage(controller.fixedCollection.value.gatheringReward)
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.sp),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      renderCollectionDifficultyGrade(controller.fixedCollection.value.gatheringDifficultyType),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.sp),
                                        child: Text(
                                          controller.fixedCollection.value.name,
                                          style: AppTextStyleData
                                              .regular()
                                              .koBodyMediumXl
                                              .copyWith(
                                            color: AppColorData
                                                .regular()
                                                .colorTextPrimary,
                                          ),
                                        ),
                                        // AnimatedGaugeWidget(percentage: 75),

                                      ),
                                      controller.fixedCollection.value.alreadyIssued
                                          ? Padding(
                                        padding: EdgeInsets.only(top: 8.0.sp),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/images/common/ico_collection_complete.svg', width: 20.sp, height: 20.sp),
                                            Padding(
                                              padding: EdgeInsets.only(left: 4.0.sp),
                                              child: Text(
                                                '컬렉션 완료',
                                                style: AppTextStyleData
                                                    .regular()
                                                    .koBodyMediumMd
                                                    .copyWith(
                                                  color: AppColorData
                                                      .regular()
                                                      .colorTextPrimary,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.0.sp),
                                            child: Row(
                                              children: [
                                                CustomPaint(
                                                  size: Size(148.sp, 8.sp),
                                                  painter: GaugePainter(
                                                      percentage: controller.fixedCollection.value.completeQuantity != null ? (controller.fixedCollection.value.completeQuantity! / controller
                                                          .fixedCollection.value.gatheringConditions.length) * 100 : 0,
                                                      fillColor: AppColorData
                                                          .regular()
                                                          .colorPointCyan,
                                                      backgroundColor: AppColorData
                                                          .regular()
                                                          .colorBgPrimary
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8.0.sp),
                                                  child: Text(
                                                    '${controller.fixedCollection.value.completeQuantity != null ? controller.fixedCollection.value.completeQuantity : 0}/${controller.fixedCollection
                                                        .value.gatheringConditions.length}',
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

                                              ],
                                            ),
                                          ),
                                          controller.fixedCollection.value.completeQuantity != null &&
                                              controller.fixedCollection.value.completeQuantity! == controller.fixedCollection.value.gatheringConditions.length ? Padding(
                                            padding: EdgeInsets.only(top: 4.0.sp),
                                            child: Text(
                                              '리워드 받기!',
                                              style: AppTextStyleData
                                                  .regular()
                                                  .koBodyMediumMd
                                                  .copyWith(
                                                color: AppColorData
                                                    .regular()
                                                    .colorTextPrimary,
                                              ),
                                            ),
                                          ) : Container(),
                                        ],
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) : const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: SizedBox.square(dimension: 50, child: CircularProgressIndicator()),
                    )),
                    controller.collectionList.isNotEmpty ?
                      Padding(
                        padding: EdgeInsets.all(16.0.sp),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3,
                          childAspectRatio: 0.55,
                          children: [
                            ...renderCollectionList(controller, controller.collectionList),
                          ],
                        ),
                      ) : Center(child: Padding(
                      padding: EdgeInsets.only(top:150.0.sp),
                      child: SizedBox.square(dimension: 50, child: CircularProgressIndicator()),
                    )),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
