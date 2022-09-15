import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/inventory_controller.dart';

class InventoryBadgeDetail extends StatelessWidget {
  const InventoryBadgeDetail({Key? key}) : super(key: key);

  List<Widget> renderBadgeList(InventoryController controller) {
    return controller.badgeList
        .map(
          (badge) => Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(children: [
                    Container(
                      child: Image(
                        image: AssetImage(badge.badgeImageUrl),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(badge.badgeName),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('·'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('LV${badge.level}'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('(${badge.getDate})'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('+${badge.effect}%'),
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
    InventoryController controller = Get.put(InventoryController());
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text('#58795008'),
                          ),
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
                                      image: AssetImage('assets/images/@temp_badge.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text('Lv.1 만월산 등정 뱃지'),
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
                          child: Row(children: [Text('이동 보상율'), Spacer(), Text('15%')]),
                        ),
                        LinearProgressIndicator(
                          value: 0.15,
                          minHeight: 10,
                          backgroundColor: const Color(0xffb74093),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(children: [Text('행운지수율'), Spacer(), Text('85%')]),
                        ),
                        LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 10,
                          backgroundColor: const Color(0xffb74093),
                        ),
                      ],
                    ),
                  ),
                  Column(
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
                            child: Text('2022.08.29'),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text('12:00:00'),
                          )
                        ]),
                      ),
                    ],
                  ),
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
                ],
              ),
            );
          }),
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
