import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_tile.dart';
import 'package:get/get.dart';

class EquippedItemsGrid extends StatelessWidget {
  const EquippedItemsGrid({
    super.key,
    required this.controller,
  });

  final InventoryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.equippedItemList.isNotEmpty) {
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          axisDirection: AxisDirection.down,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: controller.equippedShoe.value != null
                  ? InventoryTile(
                      index: 0,
                      id: controller.equippedShoe.value.id,
                      itemGrade: controller.equippedShoe.value.itemGrade,
                      durability: controller.equippedShoe.value.durability,
                      imageUrl: controller.equippedShoe.value.itemImageUrl,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: controller.equippedBadge.value != null
                  ? InventoryTile(
                      index: 1,
                      imageUrl: controller.equippedBadge.value.badge.imageUrl,
                      badgeId: controller.equippedBadge.value.badge.id,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: controller.equippedHat.value != null
                  ? InventoryTile(
                      index: 2,
                      id: controller.equippedHat.value.id,
                      itemGrade: controller.equippedHat.value.itemGrade,
                      imageUrl: controller.equippedHat.value.itemImageUrl,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: controller.equippedTop.value != null
                  ? InventoryTile(
                      index: 3,
                      id: controller.equippedTop.value.id,
                      itemGrade: controller.equippedTop.value.itemGrade,
                      imageUrl: controller.equippedTop.value.itemImageUrl,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: controller.equippedBottom.value != null
                  ? InventoryTile(
                      index: 4,
                      id: controller.equippedBottom.value.id,
                      itemGrade: controller.equippedBottom.value.itemGrade,
                      imageUrl: controller.equippedBottom.value.itemImageUrl,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: controller.equippedAccessory.value != null
                  ? InventoryTile(
                      index: 5,
                      id: controller.equippedAccessory.value.id,
                      itemGrade: controller.equippedAccessory.value.itemGrade,
                      imageUrl: controller.equippedAccessory.value.itemImageUrl,
                    )
                  : const InventoryTilePlaceHolder(),
            ),
          ],
        );
      } else {
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          axisDirection: AxisDirection.down,
          children: const [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: InventoryTilePlaceHolder(),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: InventoryTilePlaceHolder(),
            ),
          ],
        );
      }
    });
  }
}
