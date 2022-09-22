import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class InventoryBadgeDetail extends StatelessWidget {
  const InventoryBadgeDetail({Key? key}) : super(key: key);

  List<Widget> renderBadgeList(InventoryController controller) {
    return controller.syntheticBadgeList
        .map(
          (badge) => Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(children: [
                    Container(
                      child: Image(
                        image: AssetImage(badge.badge.imageUrl),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(badge.badge.description!),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('·'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('LV${badge.badge.level}'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('(${badge.badge.createdDate})'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('+${badge.badge.luckRate}%'),
                    )
                  ]),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.find();

    return DefaultContainer(
      titleText: '상세',
      child: SingleChildScrollView(
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
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10, bottom: 10),
                      //   child: Text(controller.selectedBadge.value.badge.description!),
                      // ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            new Container(
                              width: 100,
                              height: 100,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  image: NetworkImage(controller.selectedBadge.value.badge.imageUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (controller.selectedBadge.value.badge.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(controller.selectedBadge.value.badge.description!),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      /**/
                      child: Row(children: [Text('이동 보상율'), Spacer(), Text('${controller.selectedBadge.value.badge.rewardRate}%')]),
                    ),
                    LinearProgressIndicator(
                      value: controller.calculateProgress(controller.selectedBadge.value.badge.rewardRate),
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(children: [Text('행운 지수율'), Spacer(), Text('${controller.selectedBadge.value.badge.luckRate}%')]),
                    ),
                    LinearProgressIndicator(
                      value: controller.calculateProgress(controller.selectedBadge.value.badge.luckRate),
                      minHeight: 10,
                      backgroundColor: const Color(0xffb74093),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 5),
                      child: Row(children: [Text('획득 정보')]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(children: [
                        Container(
                          child: Text('합성'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('·'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(controller.getBadgeDate.toString()),
                        ),
                      ]),
                    ),
                  ],
                );
              }),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...renderBadgeList(controller),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.toSyntheticBadgeDetail(controller.selectedBadge.value.id),
                  child: const Text('합성'),
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
  }) : super(key: key);

  final int index;
  final String imageUrl;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.transparent,
      height: extent,
      child: Image(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
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
