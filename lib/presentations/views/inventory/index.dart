import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/equipped_items_grid.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:get/get.dart';

class InventoryHome extends StatelessWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    InventoryHomeController inventoryMenuController = Get.put(InventoryHomeController());
    controller.viewportWidth.value = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: controller.singleChildScrollController,
      child: Obx(() {
        return Padding(
          padding: EdgeInsets.only(top:12.sp),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: controller.isLoaded.value
                  ? MediaQuery.of(context).viewInsets.top + -MediaQuery.of(context).viewInsets.bottom + 80 + controller.listHeight.value + controller.equippedInfoHeight.value
                  : MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  key: controller.equippedInfoKey,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, bottom: 20.0.sp),
                      child: EquippedItemsGrid(controller: controller),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0.sp, bottom: 15.sp, left: 30.0.sp, right: 30.0.sp),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              StyledText(
                                '${controller.equippedRewardRate.toInt()}',
                                fontSize: 30,
                                color: skyBlueColor,
                                fontWeight: 500,
                                letterSpacing: -.1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    iconShopReward,
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.sp),
                                      child: StyledText(
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
                          Column(
                            children: [
                              StyledText(
                                '${controller.equippedAbrasionRate.toInt()}',
                                fontSize: 30,
                                fontWeight: 500,
                                letterSpacing: -.1,
                                color: const Color(0xFFB0A3FF),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    iconShopDurabilityLight,
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.sp),
                                      child: StyledText(
                                        '내구도',
                                        color: const Color(0xFFB0A3FF),
                                        fontSize: 12,
                                        lineHeight: 12,
                                        letterSpacing: -.1,
                                        fontWeight: 600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              StyledText(
                                '${controller.equippedStaminaReduceRate.toInt()}',
                                fontSize: 30,
                                fontWeight: 500,
                                color: lightGreenColor,
                                letterSpacing: -.1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 4.0.sp),
                                      child: iconShopStamina,
                                    ),
                                    StyledText(
                                      '체력',
                                      color: lightGreenColor,
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
                          Column(
                            children: [
                              StyledText(
                                '${controller.equippedLuckRate.toInt()}',
                                fontSize: 30,
                                fontWeight: 500,
                                color: pinkColor,
                                letterSpacing: -.1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 4.0.sp),
                                      child: iconShopLuck,
                                    ),
                                    StyledText(
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
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E0E10),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.sp),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                        child: StyledText(
                          '능력치는 수치가 높을수록 좋아요!',
                          fontWeight: 400,
                          fontSize: 10,
                          lineHeight: 10,
                          color: Color(0xFF898B92),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.sp),
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
                  ],
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
      }),
    );
  }
}
