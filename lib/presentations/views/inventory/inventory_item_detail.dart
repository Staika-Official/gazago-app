import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/view_solscan_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
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
                  padding: EdgeInsets.only(left: 22.0.sp, right: 22.0.sp, bottom: controller.selectedItem.value.publishType == 'NFT' ? 120.sp : 22.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColorData.regular().colorBgTertiary,
                          border: Border.all(
                            width: 2.sp,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.sp),
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFF000000),
                              blurRadius: 0,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
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
                                padding: EdgeInsets.only(top: 30.0.sp),
                                child: Obx(
                                  () {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.0.sp, left: 16.sp, right: 16.sp, bottom: controller.requestDetailFromWallet.value ? 28 : 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    if (controller.selectedItem.value.publishType == 'NFT')
                                                      Positioned.fill(left: 5.sp, right: 5.sp, child: SvgPicture.asset('assets/images/shop/ico_nft_detail.svg')),
                                                    Center(
                                                      child: SizedBox(
                                                        child: controller.selectedItem.value.itemImageUrl.contains('.svg')
                                                            ? SvgPicture.network(
                                                                fit: BoxFit.fitHeight,
                                                                height: 170.sp,
                                                                controller.selectedItem.value.itemImageUrl,
                                                                placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                                headers: imageNetworkHeader,
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl: controller.selectedItem.value.itemImageUrl,
                                                                height: 170.sp,
                                                                fit: BoxFit.fitHeight,
                                                                placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                                httpHeaders: imageNetworkHeader,
                                                              ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (controller.selectedItem.value.serialNumber != null && controller.selectedItem.value.serialNumber != '')
                                                Container(
                                                  margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: AppColorData.regular().colorBorderTertiary),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Text(
                                                    '#${controller.selectedItem.value.serialNumber ?? ''}',
                                                    style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                                                          color: AppColorData.regular().colorTextTertiary,
                                                        ),
                                                  ),
                                                ),
                                              if (controller.selectedItem.value.nftTokenAddress != null)
                                                ViewSolscanButton(onTap: () => controller.moveToSolscan(controller.selectedItem.value.nftTokenAddress!)),
                                              if (controller.isShoe.value)
                                                Container(
                                                  margin: const EdgeInsets.only(top: 32),
                                                  height: 36,
                                                  child: Stack(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
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
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Color(0xFF000000),
                                                                          blurRadius: 0,
                                                                          offset: Offset(0, 2),
                                                                          spreadRadius: 0,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  controller.selectedItem.value.durability! > 1.0
                                                                      ? LayoutBuilder(
                                                                          builder: (context, constraints) {
                                                                            return Container(
                                                                              width: controller.selectedItem.value.durability! > 20
                                                                                  ? constraints.maxWidth / (100 / controller.selectedItem.value.durability!)
                                                                                  : controller.selectedItem.value.durability! < 2
                                                                                      ? 0
                                                                                      : 34,
                                                                              decoration: BoxDecoration(
                                                                                color: controller.selectedItem.value.durability! <= 30 ? textRedColor : AppColorData.regular().colorPointPurple,
                                                                                border: Border.all(
                                                                                  width: 2.sp,
                                                                                  color: Colors.black,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(30.sp),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                      : Container(),
                                                                ],
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
                                                                Text('내구도 저항',
                                                                    style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                                                                          color: controller.selectedItem.value.durability!.toInt() <= 30 ? Colors.white : Colors.black,
                                                                        )),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 2.0.sp),
                                                                  child: Text(formatDecimalPlaces(controller.selectedItem.value.durability!, 2),
                                                                      style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                                                            color: controller.selectedItem.value.durability!.toInt() <= 30 ? Colors.white : Colors.black,
                                                                          )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () => controller.isDisableButton.value ? null : controller.showShoesRepairPopup(controller.selectedItem.value.id, context),
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: ShapeDecoration(
                                                              color: AppColorData.regular().colorPointPurple,
                                                              shape: RoundedRectangleBorder(
                                                                side: const BorderSide(width: 2),
                                                                borderRadius: BorderRadius.circular(999),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: SizedBox(
                                                                child: iconPlusThin,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 20.0.sp),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColorData.regular().colorBgPrimary,
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 12, bottom: 16),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.goProfit! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      formatDecimalPlaces(controller.selectedItem.value.itemStat!.goProfit!, 0),
                                                                      style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointCyan,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          iconShopRewardPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              'GO 적립량',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointCyan,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null &&
                                                                controller.selectedItem.value.itemStat!.goProfit! > 0 &&
                                                                (controller.selectedItem.value.itemStat!.durability! > 0 ||
                                                                    controller.selectedItem.value.itemStat!.stamina! > 0 ||
                                                                    controller.selectedItem.value.itemStat!.luck! > 0))
                                                              SizedBox(
                                                                height: 42.sp,
                                                                child: VerticalDivider(
                                                                  color: AppColorData.regular().colorBorderPrimary,
                                                                  width: 1,
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.durability! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      formatDecimalPlaces(controller.selectedItem.value.itemStat!.durability!, 0),
                                                                      style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointPurple,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          iconShopDurabilityLightPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              '내구도 저항',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointPurple,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null &&
                                                                (controller.selectedItem.value.itemStat!.goProfit! > 0 || controller.selectedItem.value.itemStat!.durability! > 0) &&
                                                                (controller.selectedItem.value.itemStat!.stamina! > 0 || controller.selectedItem.value.itemStat!.luck! > 0))
                                                              SizedBox(
                                                                height: 42.sp,
                                                                child: VerticalDivider(
                                                                  color: AppColorData.regular().colorBorderPrimary,
                                                                  width: 1,
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.stamina! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      formatDecimalPlaces(controller.selectedItem.value.itemStat!.stamina!, 0),
                                                                      style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointYellowgreen,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          iconShopStaminaPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              '체력 저항',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointYellowgreen,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null &&
                                                                controller.selectedItem.value.itemStat!.luck! > 0 &&
                                                                (controller.selectedItem.value.itemStat!.durability! > 0 ||
                                                                    controller.selectedItem.value.itemStat!.stamina! > 0 ||
                                                                    controller.selectedItem.value.itemStat!.goProfit! > 0))
                                                              SizedBox(
                                                                height: 42.sp,
                                                                child: VerticalDivider(
                                                                  color: AppColorData.regular().colorBorderPrimary,
                                                                  width: 1,
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.luck! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      formatDecimalPlaces(controller.selectedItem.value.itemStat!.luck!, 0),
                                                                      style: AppTextStyleData.regular().enBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointPink,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          iconShopLuckPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              '행운',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointPink,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat!.repairDurability! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '+${formatDecimalPlaces(controller.selectedItem.value.itemStat!.repairDurability!, 0)}',
                                                                      style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointPurple,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          iconShopDurabilityLightPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              '내구도 수리',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointPurple,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.selectedItem.value.itemStat!.recoveryStamina! > 0)
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '+${formatDecimalPlaces(controller.selectedItem.value.itemStat!.recoveryStamina!, 0)}',
                                                                      style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                                                            color: AppColorData.regular().colorPointYellowgreen,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(top: 3.sp),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          iconShopStaminaPng,
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 4.0.sp),
                                                                            child: Text(
                                                                              '체력 회복',
                                                                              style: AppTextStyleData.regular().koCaptionMediumMd.copyWith(
                                                                                    color: AppColorData.regular().colorPointYellowgreen,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            // if(controller.selectedItem.value.)
                                                            // if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.recoveryStamina! > 0)
                                                            //   Expanded(
                                                            //     child: Column(
                                                            //       children: [
                                                            //         StyledText(
                                                            //           '+${formatDecimalPlaces(controller.selectedItem.value.itemStat!.recoveryStamina!, 0)}',
                                                            //           fontSize: 26,
                                                            //           lineHeight: 26,
                                                            //           fontWeight: 500,
                                                            //           color: lightGreenColor,
                                                            //           letterSpacing: -.1,
                                                            //         ),
                                                            //         Padding(
                                                            //           padding: EdgeInsets.only(top: 8.0.sp),
                                                            //           child: Row(
                                                            //             mainAxisAlignment: MainAxisAlignment.center,
                                                            //             children: [
                                                            //               Padding(
                                                            //                 padding: EdgeInsets.only(right: 4.0.sp),
                                                            //                 child: iconShopStamina,
                                                            //               ),
                                                            //               StyledText(
                                                            //                 '체력 회복',
                                                            //                 color: lightGreenColor,
                                                            //                 fontSize: 12,
                                                            //                 lineHeight: 12,
                                                            //                 fontWeight: 500,
                                                            //                 letterSpacing: -.1,
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // if (controller.selectedItem.value.itemStat != null && controller.selectedItem.value.itemStat!.repairDurability! > 0)
                                                            //   Expanded(
                                                            //     child: Column(
                                                            //       children: [
                                                            //         StyledText(
                                                            //           '+${formatDecimalPlaces(controller.selectedItem.value.itemStat!.repairDurability!, 0)}',
                                                            //           fontSize: 26,
                                                            //           lineHeight: 26,
                                                            //           fontWeight: 500,
                                                            //           letterSpacing: -.1,
                                                            //           color: const Color(0xFFB0A3FF),
                                                            //         ),
                                                            //         Padding(
                                                            //           padding: EdgeInsets.only(top: 8.0.sp),
                                                            //           child: Row(
                                                            //             mainAxisAlignment: MainAxisAlignment.center,
                                                            //             crossAxisAlignment: CrossAxisAlignment.center,
                                                            //             children: [
                                                            //               iconShopDurabilityLight,
                                                            //               Padding(
                                                            //                 padding: EdgeInsets.only(left: 4.0.sp),
                                                            //                 child: const StyledText(
                                                            //                   '내구도 수리',
                                                            //                   color: Color(0xFFB0A3FF),
                                                            //                   fontSize: 12,
                                                            //                   lineHeight: 12,
                                                            //                   letterSpacing: -.1,
                                                            //                   fontWeight: 600,
                                                            //                 ),
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.extTxt != null)
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 24.0.sp),
                                                          child: StyledText(
                                                            controller.selectedItem.value.challenge!.extTxt!,
                                                            fontSize: 14,
                                                            letterSpacing: -.1,
                                                            lineHeight: 22,
                                                            color: lightGrayColor,
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.linkUrl != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 28.0.sp, left: 20.sp, right: 20.sp),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: popupBgColor,
                                                border: Border.all(
                                                  width: 2,
                                                  style: BorderStyle.solid,
                                                  color: Colors.black,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    offset: Offset(0.sp, 3.sp),
                                                  )
                                                ],
                                              ),
                                              child: InkWell(
                                                onTap: () => controller.moveToExternalBrowser(controller.selectedItem.value.challenge!.linkUrl),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 18.sp),
                                                  child: Center(
                                                    child: controller.selectedItem.value.challenge!.extBtnLabel != null
                                                        ? StyledText(
                                                            controller.selectedItem.value.challenge!.extBtnLabel!,
                                                            fontSize: 18,
                                                            fontWeight: 500,
                                                            lineHeight: 18,
                                                            letterSpacing: -.1,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.extTxtDetail != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.0.sp, left: 20.sp, right: 20.sp),
                                            child: StyledText(
                                              controller.selectedItem.value.challenge!.extTxtDetail!,
                                              fontSize: 12,
                                              letterSpacing: -.1,
                                              lineHeight: 18,
                                              color: deepGrayColor,
                                            ),
                                          ),
                                        if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.challengeId != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 30.sp, bottom: 0.sp, left: 20.sp, right: 20.sp),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 10.sp),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const StyledText(
                                                            '연관 챌린지',
                                                            fontWeight: 600,
                                                            fontSize: 18,
                                                            lineHeight: 18,
                                                          ),
                                                          InkWell(
                                                            onTap: () => controller.moveChallengeDetail(),
                                                            child: Row(
                                                              children: [
                                                                const StyledText(
                                                                  '바로가기',
                                                                  color: lightGrayColor,
                                                                  fontSize: 14,
                                                                  lineHeight: 16,
                                                                  fontWeight: 600,
                                                                  letterSpacing: -.1,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 4.0.sp),
                                                                  child: iconArrowRightTriangle,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (controller.selectedItem.value.challenge!.bannerImageUrl != null)
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 12.0.sp),
                                                          child: CachedNetworkImage(
                                                            imageUrl: controller.selectedItem.value.challenge!.bannerImageUrl!,
                                                            width: double.infinity,
                                                            height: 82,
                                                            fit: BoxFit.fitWidth,
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(12.sp),
                                                                ),
                                                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                              ),
                                                            ),
                                                            placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                            errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                            httpHeaders: imageNetworkHeader,
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (!controller.requestDetailFromWallet.value)
                                          Padding(
                                            padding: EdgeInsets.only(top: 25.sp, bottom: 40.sp, left: 18.sp, right: 18.sp),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 10.sp),
                                                  child: const StyledText(
                                                    '아이템 설명',
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
                                        if (controller.selectedItem.value.itemCategory != 'DISPOSABLE' && !controller.requestDetailFromWallet.value)
                                          controller.selectedItem.value.equipped == true
                                              ? Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 5.0.sp, bottom: 30.sp),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: popupBgColor,
                                                        border: Border.all(
                                                          width: 1,
                                                          style: BorderStyle.solid,
                                                          color: AppColorData.regular().colorTextInteractivePrimaryPressed,
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
                                                              Text(
                                                                '장착 중',
                                                                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                                                      color: AppColorData.regular().colorTextInteractivePrimaryPressed,
                                                                    ),
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
                                                    padding: EdgeInsets.only(top: 5.0.sp, bottom: 30.sp),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: popupBgColor,
                                                        border: Border.all(
                                                          width: 2,
                                                          style: BorderStyle.solid,
                                                          color: AppColorData.regular().colorBorderInteractivePrimary,
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
                                                        onTap: () => controller.checkEquippedChallengeItem(controller.selectedItem.value.equippedChallengeItem, controller.selectedItem.value.id),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 30.sp),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                '장착하기',
                                                                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                                                      color: AppColorData.regular().colorTextPrimary,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        if (controller.selectedItem.value.expiredDate != null)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(.2),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                                              child: Center(
                                                child: StyledText(
                                                  '아이템 사용 기한: ${formatDateUntilTime(controller.selectedItem.value.expiredDate)} 소멸 예정',
                                                  color: lightGrayColor,
                                                  fontSize: 12,
                                                  fontWeight: 500,
                                                  letterSpacing: -0.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (controller.selectedItem.value.publishType == 'NFT')
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: context.mediaQuerySize.width,
                padding: const EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 36),
                color: AppColorData.regular().colorBgPrimary,
                child: Obx(() {
                  return GazagoButton(
                    onTap: controller.selectedItem.value.equipped == true
                        ? () => showItemIsEquippedAlert()
                        : () => controller.confirmSendNftToStaika(
                              controller,
                              controller.selectedItem.value,
                            ),
                    buttonText: 'Staika 지갑으로 보내기',
                    buttonColor: controller.selectedItem.value.equipped == true ? AppColorData.regular().colorBgInteractivePrimaryDisabled : AppColorData.regular().colorBgInteractivePrimary,
                    textColor: AppColorData.regular().colorTextInverse,
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
