import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:get/get.dart';

class InventoryHome extends StatefulWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  State<InventoryHome> createState() => _InventoryHomeState();
}

class _InventoryHomeState extends State<InventoryHome> {
  InventoryHomeController inventoryMenuController = Get.put(InventoryHomeController());
  InventoryController controller = Get.put(InventoryController());

  @override
  void initState() {
    controller.initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: StyledText('[장착 중인 아이템]'),
                    ),
                    Obx(() {
                      return StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: [
                          if (controller.equippedItemList.isNotEmpty) ...[
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
                                imageUrl: controller.equippedBadge.value.badge.imageUrl,
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
                          ]
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(children: [StyledText('아이템마모율'), Spacer(), StyledText('${controller.equippedAbrasionRate}%')]),
                    ),
                    LinearProgressIndicator(
                      value: controller.calculateProgress(controller.equippedAbrasionRate),
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      /**/
                      child: Row(children: [StyledText('이동 보상율'), Spacer(), StyledText('${controller.equippedRewardRate}%')]),
                    ),
                    LinearProgressIndicator(
                      value: controller.calculateProgress(controller.equippedRewardRate),
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(children: [StyledText('체력 감소율'), Spacer(), StyledText('${controller.equippedStaminaReduceRate}%')]),
                    ),
                    LinearProgressIndicator(
                      value: controller.calculateProgress(controller.equippedStaminaReduceRate),
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
                    child: StyledText(
                      '아이템',
                    ),
                  ),
                  Tab(
                    child: StyledText(
                      '뱃지',
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
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
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
