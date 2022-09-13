import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/inventory_controller.dart';

class InventoryItemDetail extends StatelessWidget {
  const InventoryItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    return SingleChildScrollView(
      child: Container(
        child: Center(
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
                          child: Text('#58795008'),
                        ),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Image(image: AssetImage('assets/images/@temp_shoe.png'), width: 200, fit: BoxFit.fill),
                              Obx(() {
                                return controller.isShoe.value
                                    ? LinearProgressIndicator(
                                        value: 0.80,
                                        minHeight: 10,
                                        backgroundColor: const Color(0xffb74093),
                                      )
                                    : Container();
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text('블랙야크 고어텍스 트레킹화'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Obx(() {
                        return controller.isShoe.value
                            ? Column(
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
                                ],
                              )
                            : Container();
                      }),
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(children: [Text('제품 설명')]),
                        ),
                        Text('2023년 SS 시즌을 위해 새롭게 탄생한 스테디셀러의 귀환! 4계절 부담없이 착용 가능하고 방수 기능이 탁월한 고어텍스 소재의 신발입니다. 가격에 비해 체력 감소율을 낮은 잇 아이템! 실물 제품은 전국 블랙야크 매장에서 만나 보실 수 있습니다.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
