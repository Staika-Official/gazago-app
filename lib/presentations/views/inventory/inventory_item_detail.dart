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
                                        child: Row(children: [Text('아이템마모율'), Spacer(), Text('${controller.selectedItem.value.abrasionRate.floor().toString()}%')]),
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
                            child: Row(children: [Text('이동 보상율'), Spacer(), Text('${controller.selectedItem.value.rewardRate.floor().toString()}%')]),
                          ),
                          LinearProgressIndicator(
                            value: controller.calculateProgress(controller.selectedItem.value.rewardRate),
                            minHeight: 10,
                            backgroundColor: const Color(0xffb74093),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Row(children: [Text('체력 감소율'), Spacer(), Text('${controller.selectedItem.value.staminaReduceRate.floor().toString()}%')]),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(children: [Text('제품 설명')]),
                            ),
                            Text(
                              controller.selectedItem.value.description.toString(),
                            ),
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
