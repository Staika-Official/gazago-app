import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItemDetail extends StatelessWidget {
  const InventoryItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.find();
    InventoryController controller = Get.put(InventoryController());
    return DefaultContainer(
        titleText: controller.selectedItem.value.itemName,
        backgroundColor: Color(0xFF1D1D26),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2A2B33),
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
                      offset: Offset(0, 1),
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: SizedBox(
                  child: Stack(
                    children: [
                      Positioned(
                        right: 18,
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: getItemGradeColor(controller.selectedItem.value.itemGrade),
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(1, 2),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 90,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: StyledText(
                              color: controller.selectedItem.value.itemGrade == 'POOR' ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                              controller.selectedItem.value.itemGrade,
                              fontWeight: 600,
                              fontSize: controller.selectedItem.value.itemGrade.length < 6 ? 10 : 8,
                              lineHeight: 10,
                              fontFamily: 'Montserrat',
                              letterSpacing: controller.selectedItem.value.itemGrade.length < 6 ? 4 : 1.5,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20.0),
                        child: Obx(
                          () {
                            return Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                      children: [
                                        Image(
                                          image: NetworkImage(controller.selectedItem.value.itemImageUrl),
                                          width: 200,
                                          fit: BoxFit.fill,
                                        ),
                                        if (controller.isShoe.value)
                                          SizedBox(
                                            height: 34,
                                            child: Stack(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        child: SizedBox(
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFF606167),
                                                                  border: Border.all(
                                                                    width: 2,
                                                                    color: Colors.black,
                                                                  ),
                                                                  borderRadius: const BorderRadius.all(
                                                                    Radius.circular(50),
                                                                  ),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Colors.black,
                                                                      offset: Offset(0, 0),
                                                                      blurRadius: 0.0,
                                                                      spreadRadius: 0.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              controller.selectedItem.value.durability > 1.0
                                                                  ? LayoutBuilder(builder: (context, constraints) {
                                                                      return Container(
                                                                        width: controller.selectedItem.value.durability > 20
                                                                            ? constraints.maxWidth / (100 / controller.selectedItem.value.durability)
                                                                            : controller.selectedItem.value.durability < 2
                                                                                ? 0
                                                                                : 34,
                                                                        decoration: BoxDecoration(
                                                                          color: controller.selectedItem.value.durability < 20 ? const Color(0xFFFF2525) : const Color(0xFFB85DFF),
                                                                          border: Border.all(
                                                                            width: 2,
                                                                            color: Colors.black,
                                                                          ),
                                                                          borderRadius: const BorderRadius.all(
                                                                            Radius.circular(30),
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0.5),
                                                                              offset: Offset(4, 0),
                                                                              blurRadius: 4.0,
                                                                              spreadRadius: 0.0,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    })
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
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 12.0, right: 7),
                                                            child: iconShoes,
                                                          ),
                                                          StyledText(
                                                            '내구도',
                                                            fontFamily: 'Montserrat',
                                                            fontWeight: 700,
                                                            fontSize: 14,
                                                            lineHeight: 14,
                                                            color: controller.selectedItem.value.durability.toInt() < 20 ? Colors.white : Colors.black,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5.0),
                                                            child: StyledText(
                                                              controller.selectedItem.value.durability.toString(),
                                                              fontWeight: 700,
                                                              fontSize: 13,
                                                              lineHeight: 14,
                                                              color: controller.selectedItem.value.durability.toInt() < 20 ? Colors.white : Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        // SizedBox(
                                        //   width: 200,
                                        //   height: 200,
                                        //   child: Stack(
                                        //     alignment: Alignment.bottomCenter,
                                        //     children: [
                                        //       Image(image: NetworkImage(controller.selectedItem.value.itemImageUrl), width: 200, fit: BoxFit.fill),
                                        //       // Obx(() {
                                        //       //   return controller.isShoe.value
                                        //       //       ? LinearProgressIndicator(
                                        //       //           value: controller.calculateProgress(controller.selectedItem.value.durability),
                                        //       //           minHeight: 10,
                                        //       //           backgroundColor: const Color(0xffb74093),
                                        //       //         )
                                        //       //       : Container();
                                        //       // }),
                                        //     ],
                                        //   ),
                                        // ),
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
                                                    color: const Color(0xFF0EE6F3),
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
                                                      fontSize: 12,
                                                      lineHeight: 12,
                                                      fontWeight: 600,
                                                      letterSpacing: .2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (controller.isShoe.value)
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
                                                      padding: const EdgeInsets.only(top: 1.0, right: 5.0),
                                                      child: iconItemAbrasion,
                                                    ),
                                                    const StyledText(
                                                      '아이템 마모율',
                                                      color: Color(0xFF8A8A8A),
                                                      fontSize: 12,
                                                      lineHeight: 12,
                                                      fontWeight: 600,
                                                      letterSpacing: .2,
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
                                                  const StyledText(
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
                                                      padding: const EdgeInsets.only(top: 1.0, right: 2.0),
                                                      child: iconStaminaReduce,
                                                    ),
                                                    const StyledText(
                                                      '체력 감소율',
                                                      color: Color(0xFF8A8A8A),
                                                      fontSize: 12,
                                                      lineHeight: 12,
                                                      fontWeight: 600,
                                                      letterSpacing: .2,
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: StyledText(
                                          '제품 설명',
                                          color: Color(0xFF8A8A8A),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                        height: (controller.isShoe.value) ? 70 : 100,
                                        child: ListView(
                                          children: [
                                            StyledText(
                                              controller.selectedItem.value.description.toString(),
                                              color: Color(0xFFE2E2E2),
                                              fontWeight: 500,
                                              fontSize: 14,
                                              lineHeight: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.selectedItem.value.equipped == false)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D1D26),
                                      border: Border.all(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: const Color(0xFF54F5FF),
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
                                      onTap: () => controller.fetchEquipItem(controller.selectedItem.value.id),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            StyledText(
                                              '장착',
                                              fontSize: 18,
                                              lineHeight: 18,
                                              fontWeight: 500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (controller.isShoe.value)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () => controller.showShoesRepairPopup(controller.selectedItem.value.id),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff0EE6F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 0,
                              spreadRadius: 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        child: Text(
                          '수리',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 16 / 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
