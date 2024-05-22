import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/synthetic_badge_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryBadgeDetail extends StatelessWidget {
  const InventoryBadgeDetail({super.key});

  List<Widget> renderBadgeList(InventoryController controller) {
    return controller.syntheticBadgeList
        .map(
          (badge) => Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.sp, bottom: 5.sp),
                child: Row(children: [
                  Image(
                    image: AssetImage(badge.badge.imageUrl),
                    width: 30.sp,
                    height: 30.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Text(badge.badge.description!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.sp),
                    child: const Text('·'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.sp),
                    child: Text('LV${badge.badge.level}'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.sp),
                    child: Text('(${badge.badge.createdDate})'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.sp),
                    child: Text('+${badge.badge.luckRate}%'),
                  )
                ]),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.find();

    SyntheticBadgeController syntheticBadgeController = Get.put(SyntheticBadgeController(controller.selectedBadge));

    return DefaultContainer(
      titleText: 'Lv.${controller.selectedBadge.value.level} ${(controller.selectedBadge.value.name != null) ? controller.selectedBadge.value.name : ''}',
      backgroundColor: mainBg01Color,
      child: Padding(
        padding: EdgeInsets.all(22.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: subBg02Color,
                border: Border.all(
                  width: 2.sp,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(14.sp),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 1),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 12.sp,
                          right: 12.sp,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: deepGrayColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.sp),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 10.0.sp),
                              child: StyledText(
                                '#${controller.selectedBadge.value.badgeId}',
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: 600,
                                lineHeight: 15,
                                color: deepGrayColor,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40.0.sp),
                              child: SizedBox(
                                height: 150.sp,
                                child: controller.selectedBadge.value.imageUrl!.contains('.svg')
                                    ? SvgPicture.network(
                                        fit: BoxFit.fitHeight,
                                        controller.selectedBadge.value.imageUrl!,
                                        placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                        headers: imageNetworkHeader,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: controller.selectedBadge.value.imageUrl!,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        httpHeaders: imageNetworkHeader,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0.sp, left: 20.sp, right: 20.sp),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: subBg01Color,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (controller.selectedBadge.value.rewardRate > 0)
                                        Expanded(
                                          child: Column(
                                            children: [
                                              StyledText(
                                                formatDecimalPlaces(controller.selectedBadge.value.rewardRate, 0),
                                                fontSize: 26,
                                                lineHeight: 26,
                                                color: skyBlueColor,
                                                fontWeight: 500,
                                                letterSpacing: -.1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8.0.sp),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    iconShopReward,
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 4.0.sp),
                                                      child: const StyledText(
                                                        'GO 보상',
                                                        color: skyBlueColor,
                                                        fontSize: 12,
                                                        lineHeight: 14,
                                                        fontWeight: 500,
                                                        letterSpacing: -.1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (controller.selectedBadge.value.rewardRate > 0 && controller.selectedBadge.value.luckRate > 0)
                                        SizedBox(
                                          height: 35.sp,
                                          child: const VerticalDivider(
                                            color: popupBgColor,
                                            width: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                      if (controller.selectedBadge.value.luckRate > 0)
                                        Expanded(
                                          child: Column(
                                            children: [
                                              StyledText(
                                                formatDecimalPlaces(controller.selectedBadge.value.luckRate, 0),
                                                fontSize: 26,
                                                lineHeight: 26,
                                                fontWeight: 500,
                                                color: pinkColor,
                                                letterSpacing: -.1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8.0.sp),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 4.0.sp),
                                                      child: iconShopLuck,
                                                    ),
                                                    const StyledText(
                                                      '행운',
                                                      color: pinkColor,
                                                      fontSize: 12,
                                                      lineHeight: 12,
                                                      fontWeight: 500,
                                                      letterSpacing: -.1,
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40.0.sp, left: 20.sp, right: 20.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const StyledText(
                                    '획득 정보',
                                    fontSize: 18,
                                    lineHeight: 18,
                                    fontWeight: 500,
                                  ),
                                  Obx(() {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 12.sp, bottom: 15.sp),
                                      child: Row(children: [
                                        StyledText(
                                          syntheticBadgeController.badgeType.value,
                                          color: lightGrayColor,
                                          fontSize: 14,
                                          fontWeight: 500,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5.sp),
                                          child: const StyledText(
                                            '·',
                                            fontSize: 14,
                                            fontWeight: 500,
                                            color: lightGrayColor,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5.sp),
                                          child: StyledText(
                                            formatDate(controller.getBadgeDate.value),
                                            fontSize: 14,
                                            fontWeight: 500,
                                            color: lightGrayColor,
                                          ),
                                        ),
                                      ]),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Obx(() {
                              return Padding(
                                padding: EdgeInsets.only(top: 20.0.sp, bottom: 20.sp),
                                child: Column(
                                  children: [
                                    controller.selectedBadge.value.state == 'EQUIPPED'
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: popupBgColor,
                                              border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color: deepGrayColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.sp),
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () => null,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 20.sp),
                                                child: const Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    StyledText(
                                                      '장착중',
                                                      fontSize: 18,
                                                      lineHeight: 18,
                                                      fontWeight: 500,
                                                      color: deepGrayColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: subBg01Color,
                                              border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color: const Color(0xFF54F5FF),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.sp),
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () => controller.fetchEquipBadge(controller.selectedBadge.value.badgeId),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 20.sp),
                                                child: const Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    StyledText(
                                                      '장착',
                                                      fontSize: 18,
                                                      lineHeight: 18,
                                                      fontWeight: 500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 25.0.sp),
            //   child: StyledText(
            //     '능력치',
            //     fontWeight: 600,
            //     fontSize: 18,
            //     lineHeight: 18,
            //   ),
            // ),
            //
            // // Go 보상
            // if (controller.selectedBadge.value.rewardRate > 0)
            //   Padding(
            //     padding: EdgeInsets.only(top: 16.0.sp),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Row(
            //               children: [
            //                 iconStatGo,
            //                 Padding(
            //                   padding: EdgeInsets.only(left: 3.0),
            //                   child: StyledText(
            //                     'GO 보상',
            //                     fontWeight: 500,
            //                     fontSize: 14,
            //                     lineHeight: 15,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             StyledText(
            //               formatDecimalPlaces(controller.selectedBadge.value.rewardRate, 0),
            //               fontSize: 12,
            //               fontWeight: 500,
            //               color: skyBlueColor,
            //               letterSpacing: -.1,
            //             ),
            //           ],
            //         ),
            //         Padding(
            //           padding: EdgeInsets.only(top: 8.0.sp),
            //           child: ClipRRect(
            //             child: SizedBox(
            //               height: 11,
            //               child: Stack(
            //                 children: [
            //                   Container(
            //                     decoration: BoxDecoration(
            //                       color: subBg02Color,
            //                       borderRadius: BorderRadius.all(
            //                         Radius.circular(50.sp),
            //                       ),
            //                     ),
            //                   ),
            //                   LayoutBuilder(
            //                     builder: (context, constraints) {
            //                       return Container(
            //                         width: constraints.maxWidth / (double.parse(controller.badgeGoMax.value) / controller.selectedBadge.value.rewardRate),
            //                         decoration: BoxDecoration(
            //                           color: skyBlueColor,
            //                           borderRadius: BorderRadius.circular(30),
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // // 행운
            // if (controller.selectedBadge.value.luckRate > 0)
            //   Padding(
            //     padding: EdgeInsets.only(top: 16.0.sp),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Row(
            //               children: [
            //                 iconStatLuck,
            //                 Padding(
            //                   padding: EdgeInsets.only(left: 3.0),
            //                   child: StyledText(
            //                     '행운',
            //                     fontWeight: 500,
            //                     fontSize: 14,
            //                     lineHeight: 15,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             StyledText(
            //               formatDecimalPlaces(controller.selectedBadge.value.luckRate, 0),
            //               fontSize: 12,
            //               fontWeight: 500,
            //               color: pointPink,
            //               letterSpacing: -.1,
            //             ),
            //           ],
            //         ),
            //         Padding(
            //           padding: EdgeInsets.only(top: 8.0.sp),
            //           child: ClipRRect(
            //             child: SizedBox(
            //               height: 11,
            //               child: Stack(
            //                 children: [
            //                   Container(
            //                     decoration: BoxDecoration(
            //                       color: subBg02Color,
            //                       borderRadius: BorderRadius.all(
            //                         Radius.circular(50.sp),
            //                       ),
            //                     ),
            //                   ),
            //                   LayoutBuilder(
            //                     builder: (context, constraints) {
            //                       return Container(
            //                         width: constraints.maxWidth / (double.parse(controller.badgeLuckMax.value) / controller.selectedBadge.value.luckRate),
            //                         decoration: BoxDecoration(
            //                           color: pointPink,
            //                           borderRadius: BorderRadius.circular(30),
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  });

  final int index;
  final String imageUrl;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.transparent,
      height: extent,
      child: Image(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
      ],
    );
  }
}
