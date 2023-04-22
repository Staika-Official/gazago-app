import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItemDetail extends StatelessWidget {
  const InventoryItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());

    return DefaultContainer(
      // titleText: controller.selectedItem.value.itemName,
      titleWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.selectedItem.value.publishType == 'NFT')
            Padding(
              padding: EdgeInsets.only(right: 8.0.sp),
              child: SvgPicture.asset('assets/images/shop/ico_nft_label.svg'),
            ),
          StyledText(
            controller.selectedItem.value.itemName,
            fontSize: 18,
            lineHeight: 20,
            fontWeight: 500,
            letterSpacing: -0.02,
          ),
        ],
      ),
      backgroundColor: subBg01Color,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: subBg02Color,
                          border: Border.all(
                            width: 2.sp,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.sp),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 1.sp),
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 18.sp,
                                top: 0,
                                child: Container(
                                  child: getItemGradeIcon(controller.selectedItem.value.itemGrade),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.0.sp),
                                child: Obx(
                                  () {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 16.sp),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    if (controller.selectedItem.value.publishType == 'NFT')
                                                      Positioned.fill(left: 24.sp, right: 24.sp, child: SvgPicture.asset('assets/images/shop/ico_nft_detail.svg')),
                                                    Center(
                                                      child: SizedBox(
                                                        width: 150.sp,
                                                        child: controller.selectedItem.value.itemImageUrl.contains('.svg')
                                                            ? SvgPicture.network(
                                                                fit: BoxFit.fitWidth,
                                                                width: 170.sp,
                                                                controller.selectedItem.value.itemImageUrl,
                                                                placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl: controller.selectedItem.value.itemImageUrl,
                                                                width: 170.sp,
                                                                fit: BoxFit.fitWidth,
                                                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                              ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (controller.selectedItem.value.nftId != null)
                                                Container(
                                                  margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                                  padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: deepGrayColor),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: StyledText(
                                                    '#${controller.selectedItem.value.nftId!}',
                                                    fontSize: 14,
                                                    lineHeight: 14,
                                                    fontWeight: 600,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                              if (controller.isShoe.value)
                                                SizedBox(
                                                  height: 27.sp,
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
                                                                        color: gaugeGrayColor,
                                                                        border: Border.all(
                                                                          width: 2.sp,
                                                                          color: Colors.black,
                                                                        ),
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(50.sp),
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
                                                                        ? LayoutBuilder(
                                                                            builder: (context, constraints) {
                                                                              return Container(
                                                                                width: controller.selectedItem.value.durability > 20
                                                                                    ? constraints.maxWidth / (100 / controller.selectedItem.value.durability)
                                                                                    : controller.selectedItem.value.durability < 2
                                                                                        ? 0
                                                                                        : 34,
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.selectedItem.value.durability <= 30 ? textRedColor : purpleColor,
                                                                                  border: Border.all(
                                                                                    width: 2.sp,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(30.sp),
                                                                                  ),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.5),
                                                                                      offset: Offset(4.sp, 0),
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 0.0,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
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
                                                          Align(
                                                            alignment: Alignment.center,
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 12.0.sp, right: 7.sp),
                                                                  child: iconShoes,
                                                                ),
                                                                StyledText(
                                                                  '신발 내구도',
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight: 800,
                                                                  fontSize: 15,
                                                                  lineHeight: 21,
                                                                  color: controller.selectedItem.value.durability.toInt() <= 30 ? Colors.white : Colors.black,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 5.0.sp),
                                                                  child: StyledText(
                                                                    formatDecimalPlaces(controller.selectedItem.value.durability, 2),
                                                                    fontWeight: 800,
                                                                    fontSize: 14,
                                                                    lineHeight: 15,
                                                                    color: controller.selectedItem.value.durability.toInt() <= 30 ? Colors.white : Colors.black,
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
                                              Padding(
                                                padding: EdgeInsets.only(top: 20.0.sp),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: subBg01Color,
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 24.0.sp),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        if (controller.selectedItem.value.itemStat.goProfit! > 0)
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                StyledText(
                                                                  formatDecimalPlaces(controller.selectedItem.value.itemStat.goProfit!, 0),
                                                                  fontSize: 26,
                                                                  lineHeight: 26,
                                                                  color: skyBlueColor,
                                                                  fontWeight: 500,
                                                                  letterSpacing: -.1,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 8.0.sp),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      iconShopReward,
                                                                      Padding(
                                                                        padding: EdgeInsets.only(left: 4.0.sp),
                                                                        child: StyledText(
                                                                          'GO 보상',
                                                                          color: skyBlueColor,
                                                                          fontSize: 12,
                                                                          lineHeight: 14,
                                                                          fontWeight: 500,
                                                                          letterSpacing: -.1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.goProfit! > 0 &&
                                                            controller.selectedItem.value.itemStat.luck! < 1 &&
                                                            (controller.selectedItem.value.itemStat.durability! > 0 || controller.selectedItem.value.itemStat.stamina! > 0))
                                                          Container(
                                                            height: 35.sp,
                                                            child: VerticalDivider(
                                                              color: popupBgColor,
                                                              width: 1,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.durability! > 0)
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                StyledText(
                                                                  formatDecimalPlaces(controller.selectedItem.value.itemStat.durability!, 0),
                                                                  fontSize: 26,
                                                                  lineHeight: 26,
                                                                  fontWeight: 500,
                                                                  letterSpacing: -.1,
                                                                  color: const Color(0xFFB0A3FF),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 8.0.sp),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      iconShopDurabilityLight,
                                                                      Padding(
                                                                        padding: EdgeInsets.only(left: 4.0.sp),
                                                                        child: const StyledText(
                                                                          '내구도',
                                                                          color: Color(0xFFB0A3FF),
                                                                          fontSize: 12,
                                                                          lineHeight: 12,
                                                                          letterSpacing: -.1,
                                                                          fontWeight: 600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.durability! > 0 && controller.selectedItem.value.itemStat.goProfit! < 1)
                                                          Container(
                                                            height: 35.sp,
                                                            child: VerticalDivider(
                                                              color: popupBgColor,
                                                              width: 1,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.stamina! > 0)
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                StyledText(
                                                                  formatDecimalPlaces(controller.selectedItem.value.itemStat.stamina!, 0),
                                                                  fontSize: 26,
                                                                  lineHeight: 26,
                                                                  fontWeight: 500,
                                                                  color: lightGreenColor,
                                                                  letterSpacing: -.1,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 8.0.sp),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.only(right: 4.0.sp),
                                                                        child: iconShopStamina,
                                                                      ),
                                                                      StyledText(
                                                                        '체력',
                                                                        color: lightGreenColor,
                                                                        fontSize: 12,
                                                                        lineHeight: 12,
                                                                        fontWeight: 500,
                                                                        letterSpacing: -.1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.luck! > 0)
                                                          Container(
                                                            height: 35.sp,
                                                            child: VerticalDivider(
                                                              color: popupBgColor,
                                                              width: 1,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                        if (controller.selectedItem.value.itemStat.luck! > 0)
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                StyledText(
                                                                  formatDecimalPlaces(controller.selectedItem.value.itemStat.luck!, 0),
                                                                  fontSize: 26,
                                                                  lineHeight: 26,
                                                                  fontWeight: 500,
                                                                  color: pinkColor,
                                                                  letterSpacing: -.1,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 8.0.sp),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.only(right: 4.0.sp),
                                                                        child: iconShopLuck,
                                                                      ),
                                                                      StyledText(
                                                                        '행운',
                                                                        color: pinkColor,
                                                                        fontSize: 12,
                                                                        lineHeight: 12,
                                                                        fontWeight: 500,
                                                                        letterSpacing: -.1,
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
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 25.sp, bottom: 40.sp, left: 18.sp, right: 18.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 10.sp),
                                                child: const StyledText(
                                                  '제품 설명',
                                                  fontWeight: 600,
                                                  fontSize: 18,
                                                  lineHeight: 18,
                                                ),
                                              ),
                                              StyledText(
                                                controller.selectedItem.value.description.toString(),
                                                color: lightGrayColor,
                                                fontWeight: 500,
                                                fontSize: 14,
                                                lineHeight: 22,
                                                letterSpacing: -.1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        controller.selectedItem.value.equipped == true
                                            ? Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 5.0.sp),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: popupBgColor,
                                                      border: Border.all(
                                                        width: 1,
                                                        style: BorderStyle.solid,
                                                        color: deepGrayColor,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(30.sp),
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
                                                      onTap: null,
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 30.sp),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            StyledText(
                                                              '장착중',
                                                              fontSize: 18,
                                                              lineHeight: 18,
                                                              fontWeight: 500,
                                                              color: deepGrayColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 5.0.sp),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: popupBgColor,
                                                      border: Border.all(
                                                        width: 1,
                                                        style: BorderStyle.solid,
                                                        color: const Color(0xFF54F5FF),
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(30.sp),
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
                                                        padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 30.sp),
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

                      // // Go 보상
                      // if (controller.selectedItem.value.itemStat.goProfit! > 0)
                      //   Padding(
                      //     padding: EdgeInsets.only(top: 16.0.sp),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 iconStatGo,
                      //                 const Padding(
                      //                   padding: EdgeInsets.only(left: 8.0),
                      //                   child: StyledText(
                      //                     'GO 보상',
                      //                     fontWeight: 500,
                      //                     fontSize: 14,
                      //                     lineHeight: 15,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             StyledText(
                      //               formatDecimalPlaces(controller.selectedItem.value.itemStat.goProfit!, 0),
                      //               fontSize: 12,
                      //               fontWeight: 500,
                      //               color: skyBlueColor,
                      //               letterSpacing: -.1,
                      //             ),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(top: 8.0.sp),
                      //           child: ClipRRect(
                      //             child: SizedBox(
                      //               height: 11,
                      //               child: Stack(
                      //                 children: [
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       color: subBg02Color,
                      //                       borderRadius: BorderRadius.all(
                      //                         Radius.circular(50.sp),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   LayoutBuilder(
                      //                     builder: (context, constraints) {
                      //                       return Container(
                      //                         width: constraints.maxWidth / (double.parse(controller.itemGoMax.value) / controller.selectedItem.value.itemStat.goProfit!),
                      //                         decoration: BoxDecoration(
                      //                           color: skyBlueColor,
                      //                           borderRadius: BorderRadius.all(
                      //                             Radius.circular(30.sp),
                      //                           ),
                      //                         ),
                      //                       );
                      //                     },
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // // 내구도
                      // if (controller.selectedItem.value.itemStat.durability! > 0)
                      //   Padding(
                      //     padding: EdgeInsets.only(top: 20.0.sp),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 iconStatDurabilityLight,
                      //                 const Padding(
                      //                   padding: EdgeInsets.only(left: 8.0),
                      //                   child: StyledText(
                      //                     '내구도',
                      //                     fontWeight: 500,
                      //                     fontSize: 14,
                      //                     lineHeight: 15,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             StyledText(
                      //               formatDecimalPlaces(controller.selectedItem.value.itemStat.durability!, 0),
                      //               fontSize: 12,
                      //               fontWeight: 500,
                      //               color: lightPurpleColor,
                      //               letterSpacing: -.1,
                      //             ),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(top: 8.0.sp),
                      //           child: ClipRRect(
                      //             child: SizedBox(
                      //               height: 11,
                      //               child: Stack(
                      //                 children: [
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       color: subBg02Color,
                      //                       borderRadius: BorderRadius.all(
                      //                         Radius.circular(50.sp),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   LayoutBuilder(
                      //                     builder: (context, constraints) {
                      //                       return Container(
                      //                         width: constraints.maxWidth / (double.parse(controller.itemDurabilityMax.value) / controller.selectedItem.value.itemStat.durability!),
                      //                         decoration: BoxDecoration(
                      //                           color: lightPurpleColor,
                      //                           borderRadius: BorderRadius.all(
                      //                             Radius.circular(30.sp),
                      //                           ),
                      //                         ),
                      //                       );
                      //                     },
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // // 체력
                      // if (controller.selectedItem.value.itemStat.stamina! > 0)
                      //   Padding(
                      //     padding: EdgeInsets.only(top: 16.0.sp),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 iconStatStamina,
                      //                 const Padding(
                      //                   padding: EdgeInsets.only(left: 8.0),
                      //                   child: StyledText(
                      //                     '체력',
                      //                     fontWeight: 500,
                      //                     fontSize: 14,
                      //                     lineHeight: 15,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             StyledText(
                      //               formatDecimalPlaces(controller.selectedItem.value.itemStat.stamina!, 0),
                      //               fontSize: 12,
                      //               fontWeight: 500,
                      //               color: lightGreenColor,
                      //               letterSpacing: -.1,
                      //             ),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(top: 8.0.sp),
                      //           child: ClipRRect(
                      //             child: SizedBox(
                      //               height: 11,
                      //               child: Stack(
                      //                 children: [
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       color: subBg02Color,
                      //                       borderRadius: BorderRadius.all(
                      //                         Radius.circular(50.sp),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   LayoutBuilder(
                      //                     builder: (context, constraints) {
                      //                       return Container(
                      //                         width: constraints.maxWidth / (double.parse(controller.itemHealthMax.value) / controller.selectedItem.value.itemStat.stamina!),
                      //                         decoration: BoxDecoration(
                      //                           color: lightGreenColor,
                      //                           borderRadius: BorderRadius.all(
                      //                             Radius.circular(30.sp),
                      //                           ),
                      //                         ),
                      //                       );
                      //                     },
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      //
                      // // 행운
                      // if (controller.selectedItem.value.itemStat.luck! > 0)
                      //   Padding(
                      //     padding: EdgeInsets.only(top: 16.0.sp),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 iconStatLuck,
                      //                 const Padding(
                      //                   padding: EdgeInsets.only(left: 8.0),
                      //                   child: StyledText(
                      //                     '행운',
                      //                     fontWeight: 500,
                      //                     fontSize: 14,
                      //                     lineHeight: 15,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             StyledText(
                      //               formatDecimalPlaces(controller.selectedItem.value.itemStat.luck!, 0),
                      //               fontSize: 12,
                      //               fontWeight: 500,
                      //               color: pinkColor,
                      //               letterSpacing: -.1,
                      //             ),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(top: 8.0.sp),
                      //           child: ClipRRect(
                      //             child: SizedBox(
                      //               height: 11,
                      //               child: Stack(
                      //                 children: [
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       color: subBg02Color,
                      //                       borderRadius: BorderRadius.all(
                      //                         Radius.circular(50.sp),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   LayoutBuilder(
                      //                     builder: (context, constraints) {
                      //                       return Container(
                      //                         width: constraints.maxWidth / (double.parse(controller.itemLuckMax.value) / controller.selectedItem.value.itemStat.luck!),
                      //                         decoration: BoxDecoration(
                      //                           color: pinkColor,
                      //                           borderRadius: BorderRadius.all(
                      //                             Radius.circular(30.sp),
                      //                           ),
                      //                         ),
                      //                       );
                      //                     },
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (controller.isShoe.value)
            Positioned(
              left: 20,
              right: 20,
              bottom: 10,
              child: InkWell(
                onTap: () => controller.showShoesRepairPopup(controller.selectedItem.value.id),
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: skyBlueColor,
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4.sp),
                        blurRadius: 0,
                        spreadRadius: 0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  child: Text(
                    '내구도 충전하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      height: 16.sp / 18.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
