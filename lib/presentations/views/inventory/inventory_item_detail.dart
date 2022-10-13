import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItemDetail extends StatelessWidget {
  const InventoryItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.find();
    InventoryController controller = Get.put(InventoryController(walletMasterController));
    return DefaultContainer(
      titleText: controller.selectedItem.value.itemName,
      backgroundColor: Color(0xFF191921),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A2B33),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 1),
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Obx(() {
                  return Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1D1D26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 1),
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        StyledText(
                                          '${controller.selectedItem.value.rewardRate.toInt()}',
                                          fontSize: 28,
                                          lineHeight: 28,
                                          fontWeight: 500,
                                          color: Color(0xFF0EE6F3),
                                        ),
                                        const StyledText(
                                          '%',
                                          fontSize: 16,
                                          lineHeight: 24,
                                          fontWeight: 500,
                                          color: Color(0xFF0EE6F3),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0, right: 2.0),
                                            child: iconGoReward,
                                          ),
                                          const StyledText(
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
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StyledText(
                                        '${controller.selectedItem.value.abrasionRate.toInt()}',
                                        fontSize: 28,
                                        lineHeight: 28,
                                        fontWeight: 500,
                                        color: Color(0xFFB85DFF),
                                      ),
                                      const StyledText(
                                        '%',
                                        fontSize: 16,
                                        lineHeight: 24,
                                        fontWeight: 500,
                                        color: Color(0xFFB85DFF),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        StyledText(
                                          '${controller.selectedItem.value.staminaReduceRate.toInt()}',
                                          fontSize: 28,
                                          lineHeight: 28,
                                          fontWeight: 500,
                                          color: Color(0xFFCDFF41),
                                        ),
                                        StyledText(
                                          '%',
                                          fontSize: 16,
                                          lineHeight: 24,
                                          fontWeight: 500,
                                          color: Color(0xFFCDFF41),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
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
                              ),
                            ],
                          ),
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
                                child: Row(
                                  children: [
                                    StyledText(
                                      '제품 설명',
                                      color: Color(0xFF8A8A8A),
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
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
                                  onPressed: () => controller.showShoesRepairPopup(controller.selectedItem.value.id),
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
      ),
    );
  }
}
