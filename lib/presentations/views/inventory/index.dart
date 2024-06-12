import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/views/inventory/equipped_items_grid.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:gaza_go/theme/theme.g.dart';
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
          padding: EdgeInsets.only(top: 12.sp),
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
                              Text(
                                '${controller.equippedRewardRate.toInt()}',
                                style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorPointCyan,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: AppDoubleData.regular().numberSpacing2),
                                      child: SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child: iconShopRewardPng,
                                      ),
                                    ),
                                    Text(
                                      'GO 적립량',
                                      style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                            color: AppColorData.regular().colorPointCyan,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${controller.equippedAbrasionRate.toInt()}',
                                style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorPointPurple,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: AppDoubleData.regular().numberSpacing2),
                                      child: SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child: iconShopDurabilityLightPng,
                                      ),
                                    ),
                                    Text(
                                      '내구도 저항',
                                      style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                            color: AppColorData.regular().colorPointPurple,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${controller.equippedStaminaReduceRate.toInt()}',
                                style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorPointYellowgreen,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: AppDoubleData.regular().numberSpacing2),
                                      child: SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child: iconShopStaminaPng,
                                      ),
                                    ),
                                    Text(
                                      '체력 저항',
                                      style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                            color: AppColorData.regular().colorPointYellowgreen,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${controller.equippedLuckRate.toInt()}',
                                style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorPointPink,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: AppDoubleData.regular().numberSpacing2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: AppDoubleData.regular().numberSpacing2),
                                      child: SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child: iconShopLuckPng,
                                      ),
                                    ),
                                    Text(
                                      '행운',
                                      style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                            color: AppColorData.regular().colorPointPink,
                                          ),
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
                        child: Text(
                          '능력치는 수치가 높을수록 좋아요!',
                          style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
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
