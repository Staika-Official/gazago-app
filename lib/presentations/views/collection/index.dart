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

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.sp),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              height: 36.sp,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: stat.type == 'STAMINA'
                              ? SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.sp),
                                    ),

                                  ),
                                ),
                                stat.currentStat > 1.0
                                    ? LayoutBuilder(builder: (context, constraints) {
                                  return Container(
                                    width: stat.currentStat > 20
                                        ? constraints.maxWidth / (100 / stat.currentStat)
                                        : stat.currentStat < 2
                                        ? 0
                                        : 34,
                                    decoration: BoxDecoration(
                                      color: stat.currentStat <= 30 ? AppColorData
                                          .regular()
                                          .colorBgWarning : AppColorData
                                          .regular()
                                          .colorPointYellowgreen,
                                      border: Border.all(
                                        width: 2.sp,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     offset: const Offset(1, 0),
                                      //     blurRadius: 0.0,
                                      //     spreadRadius: 0.0,
                                      //   ),
                                      // ],

                                    ),
                                  );
                                })
                                    : Container(),
                              ],
                            ),
                          )
                              : SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(42.sp),
                                    ),
                                    // boxShadow: const [
                                    //   BoxShadow(
                                    //     color: Colors.black,
                                    //     offset: Offset(1, 0),
                                    //     blurRadius: 0.0,
                                    //     spreadRadius: 0.0,
                                    //   ),
                                    // ],

                                  ),
                                ),
                                stat.currentStat > 1.0
                                    ? LayoutBuilder(builder: (context, constraints) {
                                  return Container(
                                    width: stat.currentStat > 20
                                        ? constraints.maxWidth / (100 / stat.currentStat)
                                        : stat.currentStat < 2
                                        ? 0
                                        : 34,
                                    decoration: BoxDecoration(
                                      color: stat.currentStat <= 30 ? AppColorData
                                          .regular()
                                          .colorBgWarning : AppColorData
                                          .regular()
                                          .colorPointPurple,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     offset: const Offset(1, 0),
                                      //     blurRadius: 4.0,
                                      //     spreadRadius: 0.0,
                                      //   ),
                                      // ],
                                    ),
                                  );
                                })
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          stat.type == 'STAMINA'
                              ? Padding(
                            padding: EdgeInsets.only(left: 17.0.sp, right: 5.sp),
                            child: iconStamina,
                          )
                              : Padding(
                            padding: EdgeInsets.only(left: 15.0.sp, right: 3.sp),
                            child: iconShoes,
                          ),
                          Text(
                            stat.name,
                            style: AppTextStyleData
                                .regular()
                                .koBodySemiboldMd
                                .copyWith(
                                height: 1.1,
                                color: stat.currentStat <= 30 ? AppColorData
                                    .regular()
                                    .colorTextPrimary : AppColorData
                                    .regular()
                                    .colorTextInverse
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: Text(
                              formatDecimalPlaces(stat.currentStat, 2),
                              style: AppTextStyleData
                                  .regular()
                                  .enBodySemiboldMd
                                  .copyWith(
                                  height: 1.1,
                                  color: stat.currentStat <= 30 ? AppColorData
                                      .regular()
                                      .colorTextPrimary : AppColorData
                                      .regular()
                                      .colorTextInverse
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          stat.type == 'STAMINA'
                              ? Container(
                            decoration: BoxDecoration(
                              color: gaugeGrayColor,
                              border: Border.all(
                                width: 1.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.sp),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 17.sp,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorPointYellowgreen,
                              child: IconButton(
                                icon: iconRepairPlus,
                                splashRadius: 17.sp,
                                onPressed: () => {controller.onClickRepairStat(stat, context)},
                              ),
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: gaugeGrayColor,
                              border: Border.all(
                                width: 1.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.sp),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 17.sp,
                              backgroundColor: AppColorData
                                  .regular()
                                  .colorPointPurple,
                              child: IconButton(
                                icon: iconRepairPlus,
                                splashRadius: 17.sp,
                                onPressed: () => {controller.onClickRepairStat(stat, context)},
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
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
  }

  @override
  Widget build(BuildContext context) {
    CollectionController controller = Get.find();

    return DefaultContainer(
      // titleText: controller.selectedItem.value.itemName,
      titleWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          StyledText(
            '컬렉션',
            fontSize: 18,
            lineHeight: 20,
            fontWeight: 500,
            letterSpacing: -0.02,
          ),
        ],
      ),
      backgroundColor: subBg01Color,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.sp, right: 16.0.sp, top: 12.sp, bottom: 16.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // 100대 명산 컬렉션
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: subBg02Color,
                          border: Border.all(
                            width: 2.sp,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppDoubleData.regular().numberRadius12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 1.sp),
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0.sp),
                          child: Container(
                            decoration: BoxDecoration(
                              color: subBg02Color,
                              border: Border.all(
                                width: 2.sp,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDoubleData.regular().numberRadius12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1.sp),
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: renderCollectionImage(controller.fixedCollection.gatheringReward),
                          ),
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
    );
  }
}
