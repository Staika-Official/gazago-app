import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations//components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/equipped_items_grid.dart';
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
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 20.0.sp),
                // child: EquippedItemsGrid(controller: controller),
                child: EquippedItemsGrid(controller: controller),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.0.sp, right: 3.0.sp),
                                    child: iconItemAbrasion,
                                  ),
                                  StyledText(
                                    '내구도 감소율',
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
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
