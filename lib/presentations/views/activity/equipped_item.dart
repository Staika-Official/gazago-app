import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations//components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/equipped_items_grid.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class EquippedItems extends StatelessWidget {
  const EquippedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.isRegistered<InventoryController>() ? Get.find<InventoryController>() : Get.put(InventoryController());

    return DefaultContainer(
      backgroundColor: subBg01Color,
      titleText: '장착 아이템',
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_activity_road.png'),
            alignment: Alignment(0, 1),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 20.0.sp),
                // child: EquippedItemsGrid(controller: controller),
                child: EquippedItemsGrid(controller: controller),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0.sp, bottom: 15.sp, left: 30.0.sp, right: 30.0.sp),
                  child: Obx(() {
                    return Row(
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
                                  iconShopRewardPng,
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.0.sp),
                                    child: StyledText(
                                      'GO 적립량',
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
                              color: AppColorData.regular().colorPointPurple,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  iconShopDurabilityLightPng,
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.0.sp),
                                    child: StyledText(
                                      '내구도 저항',
                                      color: AppColorData.regular().colorPointPurple,
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
                                  iconShopStaminaPng,
                                  Padding(
                                    padding: EdgeInsets.only(right: 4.0.sp),
                                    child: StyledText(
                                      '체력 저항',
                                      color: lightGreenColor,
                                      fontSize: 12,
                                      lineHeight: 12,
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
                                    child: iconShopLuckPng,
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
                    );
                  })),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E0E10),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.sp),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                  child: const StyledText(
                    '능력치는 수치가 높을수록 좋아요!',
                    fontWeight: 400,
                    fontSize: 10,
                    lineHeight: 10,
                    color: Color(0xFF898B92),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
