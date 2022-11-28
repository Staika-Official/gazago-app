import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_tile.dart';
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
                            child: InventoryTile(
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
                            child: InventoryTile(
                              index: 1,
                              imageUrl: controller.equippedBadge.value.badge.imageUrl,
                              badgeId: controller.equippedBadge.value.badge.id,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: InventoryTile(
                              index: 2,
                              itemGrade: controller.equippedHat.value.itemGrade,
                              imageUrl: controller.equippedHat.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: InventoryTile(
                              index: 3,
                              itemGrade: controller.equippedTop.value.itemGrade,
                              imageUrl: controller.equippedTop.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: InventoryTile(
                              index: 4,
                              itemGrade: controller.equippedBottom.value.itemGrade,
                              imageUrl: controller.equippedBottom.value.itemImageUrl,
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: InventoryTile(
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
                                  color: deepGrayColor,
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
                                    '내구도 감소율',
                                    color: deepGrayColor,
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
                                  padding: EdgeInsets.only(top: 1.0.sp, right: 3.0.sp),
                                  child: iconStaminaReduce,
                                ),
                                StyledText(
                                  '체력 감소율',
                                  color: deepGrayColor,
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
                unselectedLabelColor: deepGrayColor,
                indicatorWeight: 0.1,
                isScrollable: false,
                labelPadding: const EdgeInsets.all(0),
                splashBorderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.sp),
                  topLeft: Radius.circular(15.sp),
                ),
                indicator: BoxDecoration(
                  color: popupBgColor,
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
