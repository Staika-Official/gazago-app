import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_badge.dart';
import 'package:gaza_go/presentations/views/inventory/inventory_item.dart';
import 'package:get/get.dart';

class InventoryHome extends StatelessWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController inventoryMenuController = Get.put(InventoryHomeController());
    InventoryController controller = Get.put(InventoryController());

    controller.initController();

    return SingleChildScrollView(
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
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        StyledText('${controller.equippedAbrasionRate.toInt()}'),
                        StyledText('%'),
                      ],
                    ),
                    Row(
                      children: [
                        iconGoReward,
                        StyledText('GO 보상율'),
                      ],
                    ),
                  ],
                )
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 5),
                //   child: Row(children: [StyledText('아이템마모율'), Spacer(), StyledText('${controller.equippedAbrasionRate}%')]),
                // ),
                // LinearProgressIndicator(
                //   value: controller.calculateProgress(controller.equippedAbrasionRate),
                //   minHeight: 10,
                //   backgroundColor: const Color(0xffb74093),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 5),
                //   /**/
                //   child: Row(children: [StyledText('이동 보상율'), Spacer(), StyledText('${controller.equippedRewardRate}%')]),
                // ),
                // LinearProgressIndicator(
                //   value: controller.calculateProgress(controller.equippedRewardRate),
                //   minHeight: 10,
                //   backgroundColor: const Color(0xffb74093),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 5),
                //   child: Row(children: [StyledText('체력 감소율'), Spacer(), StyledText('${controller.equippedStaminaReduceRate}%')]),
                // ),
                // LinearProgressIndicator(
                //   value: controller.calculateProgress(controller.equippedStaminaReduceRate),
                //   minHeight: 10,
                //   backgroundColor: const Color(0xffb74093),
                // ),
              ],
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF363841),
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 4),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                  ),
                ],
              ),
            ),
            durability != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: SizedBox(
                      height: 20,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  child: SizedBox(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF606167),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 3),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        durability! > 1.0
                                            ? Padding(
                                                padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                                                child: Container(
                                                  height: 16,
                                                  margin: EdgeInsets.zero,
                                                  width: durability! > 20
                                                      ? MediaQuery.of(context).size.width / (100 / durability!)
                                                      : durability! < 2
                                                          ? 0
                                                          : 34,
                                                  decoration: BoxDecoration(
                                                    color: durability! < 20 ? const Color(0xFFFF2525) : const Color(0xFFB85DFF),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: iconShoes,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF606167),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(0, 1),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Color(0xFFB85DFF),
                                  child: IconButton(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.zero,
                                    iconSize: 20.0,
                                    icon: iconPlus,
                                    onPressed: null,
                                    // onPressed: () => {controller.onClickRepairStat(stat)},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
