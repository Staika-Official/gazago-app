import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:get/get.dart';

class InventoryHome extends StatelessWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController inventoryMenuController = Get.put(InventoryHomeController());
    InventoryController controller = Get.put(InventoryController());

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text('[장착 중인 아이템]'),
                      ),
                      Obx(() {
                        return StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: Tile(
                                index: 0,
                                durability: controller.equippedShoe.value.durability,
                                imageUrl: controller.equippedShoe.value.itemImageUrl,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: Tile(
                                index: 1,
                                imageUrl: controller.equippedAccessory.value.itemImageUrl,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 2,
                                imageUrl: controller.equippedAccessory.value.itemImageUrl,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 3,
                                imageUrl: controller.equippedAccessory.value.itemImageUrl,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 4,
                                imageUrl: controller.equippedAccessory.value.itemImageUrl,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: Tile(
                                index: 5,
                                imageUrl: controller.equippedAccessory.value.itemImageUrl,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(children: [Text('아이템마모율'), Spacer(), Text('2%')]),
                    ),
                    LinearProgressIndicator(
                      value: 0.02,
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      /**/
                      child: Row(children: [Text('이동 보상율'), Spacer(), Text('15%')]),
                    ),
                    LinearProgressIndicator(
                      value: 0.15,
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(children: [Text('체력 감소율'), Spacer(), Text('85%')]),
                    ),
                    LinearProgressIndicator(
                      value: 0.85,
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                  ],
                ),
              ),
              TabBar(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                controller: inventoryMenuController.tabController,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      '아이템',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '뱃지',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: inventoryMenuController.tabController,
                  children: [
                    InventoryItem(),
                    InventoryBadge(),
                  ],
                ),
              ),
            ],
          ),
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
    this.durability,
  }) : super(key: key);

  final int index;
  final double? durability;
  final String imageUrl;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.find();
    final child = Container(
      color: Colors.transparent,
      height: extent,
      child: SizedBox(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            durability != null
                ? LinearProgressIndicator(
                    value: controller.calculateProgress(durability),
                    minHeight: 10,
                    backgroundColor: const Color(0xffb74093),
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
