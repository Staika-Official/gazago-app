import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations//components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_tile.dart';
import 'package:get/get.dart';

class EquippedItems extends StatelessWidget {
  const EquippedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());

    return DefaultContainer(
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                                StyledText(
                                  '%',
                                  fontSize: 16,
                                  fontWeight: 500,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0, right: 2.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0, right: 3.0),
                                      child: iconItemAbrasion,
                                    ),
                                    StyledText(
                                      '아이템 마모율',
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
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0, right: 3.0),
                                    child: iconStaminaReduce,
                                  ),
                                  StyledText(
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
            ],
          ),
        ),
      ),
    );
  }
}
