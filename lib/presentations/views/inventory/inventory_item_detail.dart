import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class InventoryItemDetail extends StatelessWidget {
  const InventoryItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());
    return DefaultContainer(
      titleText: '상세',
      child: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(controller.selectedItem.value.serialNumber),
                            ),
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image(image: NetworkImage(controller.selectedItem.value.itemImageUrl), width: 200, fit: BoxFit.fill),
                                  Obx(() {
                                    return controller.isShoe.value
                                        ? LinearProgressIndicator(
                                            value: controller.calculateProgress(controller.selectedItem.value.durability),
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
                              child: Text(controller.selectedItem.value.itemName),
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
                                        child: Row(children: [Text('아이템마모율'), Spacer(), Text(controller.selectedItem.value.abrasionRate.toString())]),
                                      ),
                                      LinearProgressIndicator(
                                        value: controller.calculateProgress(controller.selectedItem.value.abrasionRate),
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
                            child: Row(children: [Text('이동 보상율'), Spacer(), Text(controller.selectedItem.value.rewardRate.toString())]),
                          ),
                          LinearProgressIndicator(
                            value: controller.calculateProgress(controller.selectedItem.value.rewardRate),
                            minHeight: 10,
                            backgroundColor: const Color(0xffb74093),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Row(children: [Text('체력 감소율'), Spacer(), Text(controller.selectedItem.value.staminaReduceRate.toString())]),
                          ),
                          LinearProgressIndicator(
                            value: controller.calculateProgress(controller.selectedItem.value.staminaReduceRate),
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
                    if (controller.isShoe.value)
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => controller.showShoesRepairPopup(),
                                child: const Text('수리'),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
