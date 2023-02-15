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
          ],
        );
      } else {
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          axisDirection: AxisDirection.down,
          children: [
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
