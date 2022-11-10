import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:get/get.dart';

class InventoryHome extends StatelessWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController inventoryMenuController = Get.put(InventoryHomeController());
    InventoryController controller = Get.put(InventoryController());
    HomeMenuController homeMenuController = Get.find();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: controller.singleChildScrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, bottom: 20.0.sp),
              child: Column(
                children: [
                  Obx(() {
                    return StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      children: [
                        if (controller.equippedItemList.isNotEmpty) ...[
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(
                              index: 0,
                              id: controller.equippedShoe.value.id,
                              itemGrade: controller.equippedShoe.value.itemGrade,
                              durability: controller.equippedShoe.value.durability,
                              imageUrl: controller.equippedShoe.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(
                              index: 1,
                              imageUrl: controller.equippedBadge.value.badge.imageUrl,
                              badgeId: controller.equippedBadge.value.badge.id,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 2,
                              itemGrade: controller.equippedHat.value.itemGrade,
                              imageUrl: controller.equippedHat.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 3,
                              itemGrade: controller.equippedTop.value.itemGrade,
                              imageUrl: controller.equippedTop.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 4,
                              itemGrade: controller.equippedBottom.value.itemGrade,
                              imageUrl: controller.equippedBottom.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(
                              index: 5,
                              itemGrade: controller.equippedAccessory.value.itemGrade,
                              imageUrl: controller.equippedAccessory.value.itemImageUrl,
                            ),
                          ),
                        ]
                      ],
                    );
                  }),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                child: Obx(() {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                '${controller.equippedRewardRate.toInt()}',
                                fontSize: 28,
                                fontWeight: 500,
                              ),
                              const StyledText(
                                '%',
                                fontSize: 16,
                                fontWeight: 500,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.0.sp, right: 2.0.sp),
                                  child: iconGoReward,
                                ),
                                StyledText(
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StyledText(
                                  '${controller.equippedAbrasionRate.toInt()}',
                                  fontSize: 28,
                                  fontWeight: 500,
                                ),
                                StyledText(
                                  '%',
                                  fontSize: 16,
                                  fontWeight: 500,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.0.sp, right: 3.0.sp),
                                    child: iconItemAbrasion,
                                  ),
                                  StyledText(
                                    '아이템 마모율',
                                    color: Color(0xFF8A8A8A),
                                    fontSize: 12,
                                    lineHeight: 12,
                                    fontWeight: 600,
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
                                '${controller.equippedStaminaReduceRate.toInt()}',
                                fontSize: 28,
                                fontWeight: 500,
                              ),
                              StyledText(
                                '%',
                                fontSize: 16,
                                fontWeight: 500,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 1.0.sp, right: 3.0.sp),
                                  child: iconStaminaReduce,
                                ),
                                const StyledText(
                                  '체력 감소율',
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
                  );
                })),
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
              child: TabBar(
                controller: inventoryMenuController.tabController,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                unselectedLabelColor: const Color(0xFF8A8A8A),
                indicatorWeight: 0.1,
                isScrollable: false,
                labelPadding: const EdgeInsets.all(0),
                splashBorderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.sp),
                  topLeft: Radius.circular(15.sp),
                ),
                indicator: BoxDecoration(
                  color: Color(0xFF363841),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.sp),
                    topLeft: Radius.circular(15.sp),
                  ),
                ),
                tabs: <Widget>[
                  Tab(
                    child: Container(
                      width: double.infinity.sp,
                      height: double.infinity.sp,
                      decoration: ShapeDecoration(
                        shape: CustomRoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
                          leftSide: BorderSide(color: Colors.black, width: 2.sp),
                          topLeftCornerSide: BorderSide(color: Colors.black, width: 2.sp),
                          rightSide: BorderSide(color: Colors.black, width: 1.sp),
                          topRightCornerSide: BorderSide(color: Colors.black, width: 2.sp),
                          topSide: BorderSide(color: Colors.black, width: 2.sp),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('아이템'),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: double.infinity.sp,
                      height: double.infinity.sp,
                      decoration: ShapeDecoration(
                        shape: CustomRoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
                          leftSide: BorderSide(color: Colors.black, width: 1.sp),
                          topLeftCornerSide: BorderSide(color: Colors.black, width: 2.sp),
                          rightSide: BorderSide(color: Colors.black, width: 2.sp),
                          topRightCornerSide: BorderSide(color: Colors.black, width: 2.sp),
                          topSide: BorderSide(color: Colors.black, width: 2.sp),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('뱃지'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: inventoryMenuController.tabController,
                children: const [
                  InventoryItem(),
                  InventoryBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    this.id,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    this.durability,
    this.itemGrade,
    this.badgeId,
  }) : super(key: key);

  final int index;
  final int? id;
  final double? durability;
  final String imageUrl;
  final String? itemGrade;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final int? badgeId;

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.find();
    final child = Container(
      color: Colors.transparent,
      height: extent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF363841),
          border: Border.all(
            width: 2.sp,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(14.sp),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 4),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: badgeId != null && badgeId != -1 ? EdgeInsets.only(top: 10.0.sp, bottom: 30.sp, left: 30.sp, right: 30.sp) : EdgeInsets.all(10.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: index == 1 ? 1 / 1 : 1.2 / 1,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => iconNoBadge,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeId != null && badgeId != -1)
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.sp,
                    horizontal: 10.sp,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.sp),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xff8a8a8a),
                    ),
                  ),
                  child: StyledText(
                    '#${badgeId.toString()}',
                    fontSize: 10,
                    lineHeight: 10,
                    fontWeight: 500,
                    letterSpacing: 1,
                    fontFamily: 'Montserrat',
                    color: const Color(0xff8a8a8a),
                  ),
                ),
              ),
            durability != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 9.0.sp),
                    child: SizedBox(
                      height: 22.sp,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  child: SizedBox(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(2.0.sp),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF606167),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50.sp),
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
                                          ),
                                        ),
                                        durability! > 1.0
                                            ? Padding(
                                                padding: EdgeInsets.only(top: 2.0.sp, left: 2.0.sp),
                                                child: LayoutBuilder(builder: (context, constraints) {
                                                  return Container(
                                                    height: 18.sp,
                                                    margin: EdgeInsets.zero,
                                                    width: (durability! > 20
                                                            ? constraints.maxWidth / (100 / durability!)
                                                            : durability! < 2
                                                                ? 0
                                                                : 34)
                                                        .sp,
                                                    decoration: BoxDecoration(
                                                      color: durability! < 20 ? const Color(0xFFFF2525) : const Color(0xFFB85DFF),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(50.sp),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              )
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
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                                    child: iconShoes,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            right: -1.sp,
                            top: -1.sp,
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.0.sp),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF606167),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
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
                                  onTap: () => controller.showShoesRepairPopup(id),
                                  child: CircleAvatar(
                                    radius: 10.sp,
                                    backgroundColor: const Color(0xFFB85DFF),
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      iconSize: 20.0.sp,
                                      icon: iconPlus,
                                      onPressed: null,
                                      // onPressed: () => {controller.onClickRepairStat(stat)},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            itemGrade != null
                ? Positioned(
                    right: index > 1 ? 6.sp : 10.sp,
                    top: index > 1 ? 6.sp : 10.sp,
                    child: CircleAvatar(
                      backgroundColor: getItemGradeColor(itemGrade!),
                      radius: 10.sp,
                      child: StyledText(
                        itemGrade![0],
                        fontWeight: 600,
                        fontFamily: 'Montserrat',
                        color: itemGrade == 'POOR' ? Color(0xFFffffff).withOpacity(0.6) : Color(0xFF000000).withOpacity(0.6),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
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
