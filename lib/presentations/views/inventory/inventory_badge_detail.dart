import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/synthetic_badge_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryBadgeDetail extends StatelessWidget {
  const InventoryBadgeDetail({Key? key}) : super(key: key);

  List<Widget> renderBadgeList(InventoryController controller) {
    return controller.syntheticBadgeList
        .map(
          (badge) => Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.sp, bottom: 5.sp),
                  child: Row(children: [
                    Container(
                      child: Image(
                        image: AssetImage(badge.badge.imageUrl),
                        width: 30.sp,
                        height: 30.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.sp),
                      child: Text(badge.badge.description!),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: Text('·'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: Text('LV${badge.badge.level}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: Text('(${badge.badge.createdDate})'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: Text('+${badge.badge.luckRate}%'),
                    )
                  ]),
                ),
              ],
            ),
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
      backgroundColor: Color(0xFF191921),
      child: Padding(
        padding: EdgeInsets.all(22.sp),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2B33),
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
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12.sp,
                          right: 12.sp,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF8A8A8A),
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
                                color: Color(0xFF8A8A8A),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40.0.sp),
                              child: SizedBox(
                                width: 150.sp,
                                child: CachedNetworkImage(
                                  imageUrl: controller.selectedBadge.value.imageUrl!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 12.sp,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20.sp,
                                    horizontal: 45.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1D1D26),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.sp),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20.0.sp),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    StyledText(
                                                      '${controller.selectedBadge.value.rewardRate.toInt()}',
                                                      fontSize: 28,
                                                      lineHeight: 28,
                                                      fontWeight: 500,
                                                      color: Color(0xFF0EE6F3),
                                                    ),
                                                    const StyledText(
                                                      '%',
                                                      fontSize: 16,
                                                      lineHeight: 24,
                                                      fontWeight: 500,
                                                      color: Color(0xFF0EE6F3),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 5.0.sp),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 2.0.sp, right: 2.0.sp),
                                                        child: iconGoReward,
                                                      ),
                                                      const StyledText(
                                                        'GO 보상율',
                                                        color: Color(0xFF8A8A8A),
                                                        fontSize: 11,
                                                        lineHeight: 12,
                                                        fontWeight: 500,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  StyledText(
                                                    '${controller.selectedBadge.value.luckRate.toInt()}',
                                                    fontSize: 28,
                                                    lineHeight: 28,
                                                    fontWeight: 500,
                                                    color: Color(0xFFFF41CA),
                                                  ),
                                                  const StyledText(
                                                    '%',
                                                    fontSize: 16,
                                                    lineHeight: 24,
                                                    fontWeight: 500,
                                                    color: Color(0xFFFF41CA),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 5.0.sp),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 1.0.sp, right: 3.0.sp),
                                                      child: iconLucky,
                                                    ),
                                                    const StyledText(
                                                      '행운 지수율',
                                                      color: Color(0xFF8A8A8A),
                                                      fontSize: 11,
                                                      lineHeight: 12,
                                                      fontWeight: 500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              return Padding(
                                padding: EdgeInsets.only(top: 20.0.sp),
                                child: Column(
                                  children: [
                                    controller.selectedBadge.value.state == 'EQUIPPED'
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF363841),
                                              border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color: const Color(0xFF8A8A8A),
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
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    StyledText(
                                                      '장착중',
                                                      fontSize: 18,
                                                      lineHeight: 18,
                                                      fontWeight: 500,
                                                      color: Color(0xFF8A8A8A),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1D1D26),
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
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
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

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: Divider(thickness: 1, height: 1, color: Color(0xFF363841)),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                              child: Column(
                                children: [
                                  Row(children: const [
                                    StyledText(
                                      '획득 정보',
                                      color: Color(0xFFBFBFBF),
                                      fontSize: 14,
                                      fontWeight: 500,
                                    )
                                  ]),
                                  Obx(() {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 10.sp, bottom: 15.sp),
                                      child: Row(children: [
                                        StyledText(
                                          syntheticBadgeController.badgeType.value,
                                          color: Color(0xFF8A8A8A),
                                          fontSize: 14,
                                          fontWeight: 500,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5.sp),
                                          child: StyledText(
                                            '·',
                                            fontSize: 14,
                                            fontWeight: 500,
                                            color: Color(0xFF8A8A8A),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5.sp),
                                          child: StyledText(
                                            formatDate(controller.getBadgeDate.value),
                                            fontSize: 14,
                                            fontWeight: 500,
                                            color: Color(0xFF8A8A8A),
                                          ),
                                        ),
                                      ]),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 200,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: Column(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         ...renderBadgeList(controller),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: InkWell(
            //     onTap: () => controller.toSyntheticBadgeDetail(controller.selectedBadge.value.badge.id),
            //     child: Container(
            //       padding: const EdgeInsets.all(20),
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         color: Color(0xff0EE6F3),
            //         borderRadius: BorderRadius.circular(12),
            //         border: Border.all(
            //           width: 2,
            //           style: BorderStyle.solid,
            //           color: Colors.black,
            //         ),
            //         boxShadow: const [
            //           BoxShadow(
            //             offset: Offset(0, 4),
            //             blurRadius: 0,
            //             spreadRadius: 0,
            //             color: Colors.black,
            //           ),
            //         ],
            //       ),
            //       child: const Text(
            //         '합성',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //           height: 16 / 18,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

const _defaultColor = Color(0xFF34568B);

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

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
