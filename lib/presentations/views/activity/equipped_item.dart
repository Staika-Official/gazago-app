import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

import '../../components/default_container.dart';

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
        child: SingleChildScrollView(
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
                                  id: controller.equippedShoe.value.id,
                                  itemGrade: controller.equippedShoe.value.itemGrade,
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
                                  itemGrade: controller.equippedHat.value.itemGrade,
                                  imageUrl: controller.equippedHat.value.itemImageUrl,
                                ),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: Tile(
                                  index: 3,
                                  itemGrade: controller.equippedTop.value.itemGrade,
                                  imageUrl: controller.equippedTop.value.itemImageUrl,
                                ),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: Tile(
                                  index: 4,
                                  itemGrade: controller.equippedBottom.value.itemGrade,
                                  imageUrl: controller.equippedBottom.value.itemImageUrl,
                                ),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1,
                                child: Tile(
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
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    this.id,
    required this.index,
    required this.imageUrl,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    this.durability,
    this.itemGrade,
  }) : super(key: key);

  final int index;
  final int? id;
  final double? durability;
  final String imageUrl;
  final String? itemGrade;
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
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                      fit: BoxFit.contain,
                    ),
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
                                                child: LayoutBuilder(builder: (context, constraints) {
                                                  return Container(
                                                    height: 16,
                                                    margin: EdgeInsets.zero,
                                                    width: durability! > 20
                                                        ? constraints.maxWidth / (100 / durability!)
                                                        : durability! < 2
                                                            ? 0
                                                            : 34,
                                                    decoration: BoxDecoration(
                                                      color: durability! < 20 ? const Color(0xFFFF2525) : const Color(0xFFB85DFF),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(50),
                                                      ),
                                                    ),
                                                  );
                                                }),
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
                                child: InkWell(
                                  onTap: () => controller.showShoesRepairPopup(id),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: const Color(0xFFB85DFF),
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
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            itemGrade != null
                ? Positioned(
                    right: index > 1 ? 6 : 10,
                    top: index > 1 ? 6 : 10,
                    child: CircleAvatar(
                      backgroundColor: getItemGradeColor(itemGrade!),
                      radius: 10,
                      child: StyledText(
                        itemGrade![0],
                        fontWeight: 600,
                        fontFamily: 'Montserrat',
                        color: itemGrade == 'POOR' ? Color(0xFFffffff).withOpacity(0.6) : Color(0xFF000000).withOpacity(0.6),
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
