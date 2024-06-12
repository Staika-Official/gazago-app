import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/shop_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class ShopItemDetail extends StatelessWidget {
  const ShopItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopDetailController controller = Get.put(ShopDetailController());
    return Scaffold(
      appBar: const SecondaryAppbar(
        isShowBackButton: true,
        isShowPreferencesButton: false,
      ),
      backgroundColor: subBg01Color,
      body: Obx(() {
        return SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 22.0.sp, right: 22.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                          child: Stack(
                            children: [
                              if (controller.selectedItem.value.itemCategory != '' && controller.selectedItem.value.itemGrade != 'NONE')
                                Positioned(
                                  right: 32.sp,
                                  top: 0,
                                  child: getItemGradeIcon(controller.selectedItem.value.itemGrade),
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 20.0.sp),
                                child: Obx(
                                  () {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              // Image(
                                              //   image: AssetImage(controller.selectedItem.value.itemImageUrl!),
                                              //   width: 150.sp,
                                              //   fit: BoxFit.fill,
                                              // ),

                                              SizedBox(
                                                width: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    if (controller.selectedItem.value.publishType == 'NFT')
                                                      Positioned.fill(left: 24.sp, right: 24.sp, child: SvgPicture.asset('assets/images/shop/ico_nft_detail.svg')),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 150.sp,
                                                          child: controller.selectedItem.value.itemImageUrl != null && controller.selectedItem.value.itemImageUrl!.contains('.svg')
                                                              ? SvgPicture.network(
                                                                  fit: BoxFit.contain,
                                                                  controller.selectedItem.value.itemImageUrl!,
                                                                  placeholderBuilder: (BuildContext context) => Container(
                                                                    padding: const EdgeInsets.all(30.0),
                                                                    child: const CircularProgressIndicator(),
                                                                  ),
                                                                  headers: imageNetworkHeader,
                                                                )
                                                              : CachedNetworkImage(
                                                                  imageUrl: controller.selectedItem.value.itemImageUrl!,
                                                                  fit: BoxFit.fitWidth,
                                                                  placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                                  errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                                  httpHeaders: imageNetworkHeader,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              if (controller.selectedItem.value.publishType == 'NFT')
                                                Padding(
                                                  padding: EdgeInsets.only(right: 5.0.sp),
                                                  child: SvgPicture.asset('assets/images/shop/ico_nft_label.svg'),
                                                ),
                                              StyledText(
                                                controller.selectedItem.value.name,
                                                fontSize: 18,
                                                lineHeight: 19,
                                                fontWeight: 500,
                                              ),
                                            ],
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
                      if (controller.selectedItem.value.itemCategory != 'DISPOSABLE')
                        Padding(
                          padding: EdgeInsets.only(top: 25.0.sp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const StyledText(
                                '능력치',
                                fontWeight: 600,
                                fontSize: 18,
                                lineHeight: 19,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6.0.sp),
                                child: InkWell(
                                  onTap: () => controller.showItemTip(),
                                  child: iconExclamationMarkSmall,
                                ),
                              )
                            ],
                          ),
                        ),
                      // Go 보상
                      if (controller.selectedItem.value.maxGoProfit! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconShopRewardPng,
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: StyledText(
                                          'GO 적립량',
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.minGoProfit!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: skyBlueColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        ' - ',
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: skyBlueColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.maxGoProfit!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: skyBlueColor,
                                        letterSpacing: -.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 11,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: subBg02Color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.sp),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxGoProfit! / controller.selectedItem.value.minGoProfit!),
                                              decoration: BoxDecoration(
                                                color: skyBlueColor,
                                                borderRadius: controller.selectedItem.value.minGoProfit == controller.selectedItem.value.maxGoProfit
                                                    ? BorderRadius.all(
                                                        Radius.circular(30.sp),
                                                      )
                                                    : BorderRadius.only(topLeft: Radius.circular(30.sp), bottomLeft: Radius.circular(30.sp)),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxGoProfit! / controller.selectedItem.value.maxGoProfit!),
                                              decoration: BoxDecoration(
                                                color: skyBlueColor.withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 신발 내구도
                      if (controller.selectedItem.value.maxDurability! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconShopDurabilityLightPng,
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: StyledText(
                                          '내구도 저항',
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.minDurability!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: AppColorData.regular().colorPointPurple,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        ' - ',
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: AppColorData.regular().colorPointPurple,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.maxDurability!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: AppColorData.regular().colorPointPurple,
                                        letterSpacing: -.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 11,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: subBg02Color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.sp),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxDurability! / controller.selectedItem.value.minDurability!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular().colorPointPurple,
                                                borderRadius: controller.selectedItem.value.maxDurability == controller.selectedItem.value.minDurability
                                                    ? BorderRadius.all(
                                                        Radius.circular(30.sp),
                                                      )
                                                    : BorderRadius.only(topLeft: Radius.circular(30.sp), bottomLeft: Radius.circular(30.sp)),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxDurability! / controller.selectedItem.value.maxDurability!),
                                              decoration: BoxDecoration(
                                                color: AppColorData.regular().colorPointPurple.withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 체력
                      if (controller.selectedItem.value.maxStamina! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconShopStaminaPng,
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: StyledText(
                                          '체력 저항',
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.minStamina!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: lightGreenColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        ' - ',
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: lightGreenColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.maxStamina!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: lightGreenColor,
                                        letterSpacing: -.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 11,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: subBg02Color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.sp),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxStamina! / controller.selectedItem.value.minStamina!),
                                              decoration: BoxDecoration(
                                                color: lightGreenColor,
                                                borderRadius: controller.selectedItem.value.maxStamina == controller.selectedItem.value.minStamina
                                                    ? BorderRadius.all(
                                                        Radius.circular(30.sp),
                                                      )
                                                    : BorderRadius.only(topLeft: Radius.circular(30.sp), bottomLeft: Radius.circular(30.sp)),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxStamina! / controller.selectedItem.value.maxStamina!),
                                              decoration: BoxDecoration(
                                                color: lightGreenColor.withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      // 행운
                      if (controller.selectedItem.value.maxLuck! > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0.sp),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconShopLuckPng,
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: StyledText(
                                          '행운',
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.minLuck!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: pinkColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        ' - ',
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: pinkColor,
                                        letterSpacing: -.1,
                                      ),
                                      StyledText(
                                        formatDecimalPlaces(controller.selectedItem.value.maxLuck!, 0),
                                        fontSize: 12,
                                        fontWeight: 500,
                                        color: pinkColor,
                                        letterSpacing: -.1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 11,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: subBg02Color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.sp),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxLuck! / controller.selectedItem.value.minLuck!),
                                              decoration: BoxDecoration(
                                                color: pinkColor,
                                                borderRadius: controller.selectedItem.value.maxLuck == controller.selectedItem.value.minLuck
                                                    ? BorderRadius.all(
                                                        Radius.circular(30.sp),
                                                      )
                                                    : BorderRadius.only(topLeft: Radius.circular(30.sp), bottomLeft: Radius.circular(30.sp)),
                                              ),
                                            );
                                          },
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth / (controller.selectedItem.value.maxLuck! / controller.selectedItem.value.maxLuck!),
                                              decoration: BoxDecoration(
                                                color: pinkColor.withOpacity(.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.extTxt != null)
                        Padding(
                          padding: EdgeInsets.only(top: 20.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      iconStatEtc,
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: StyledText(
                                          controller.selectedItem.value.challenge!.extTxt!,
                                          fontWeight: 500,
                                          fontSize: 14,
                                          lineHeight: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.sp),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 11,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: subBg02Color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.sp),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFF922E),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.sp),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.selectedItem.value.challenge != null && controller.selectedItem.value.challenge!.linkUrl != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 28.0.sp),
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
                                  padding: EdgeInsets.only(top: 8.0.sp),
                                  child: StyledText(
                                    controller.selectedItem.value.challenge!.extTxtDetail!,
                                    fontSize: 12,
                                    letterSpacing: -.1,
                                    lineHeight: 18,
                                    color: deepGrayColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 5.sp),
                        decoration: BoxDecoration(
                          color: subBg01Color,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.sp),
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
                      ),
                      if (controller.selectedItem.value.challengeId != null)
                        Padding(
                          padding: EdgeInsets.only(top: 30.sp, bottom: 0.sp),
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
                                              StyledText(
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
                                    if (controller.selectedItem.value.challengeBannerImageUrl != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 12.0.sp),
                                        child: CachedNetworkImage(
                                          imageUrl: controller.selectedItem.value.challengeBannerImageUrl!,
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
                      if (controller.selectedItem.value.itemCategory == 'DISPOSABLE')
                        Padding(
                          padding: EdgeInsets.only(top: 24.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StyledText(
                                '효과',
                                fontWeight: 600,
                                fontSize: 18,
                                lineHeight: 18,
                              ),
                              if (controller.selectedItem.value.recoveryStamina != null && controller.selectedItem.value.recoveryStamina != 0)
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0.sp),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              iconShopStaminaPng,
                                              const Padding(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: StyledText(
                                                  '체력 회복',
                                                  fontWeight: 500,
                                                  fontSize: 14,
                                                  lineHeight: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          StyledText(
                                            '+${formatDecimalPlaces(controller.selectedItem.value.recoveryStamina!, 0)}',
                                            fontSize: 12,
                                            fontWeight: 500,
                                            color: lightGreenColor,
                                            letterSpacing: -.1,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0.sp),
                                        child: ClipRRect(
                                          child: SizedBox(
                                            height: 11,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: subBg02Color,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(50.sp),
                                                    ),
                                                  ),
                                                ),
                                                LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: lightGreenColor,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(30.sp),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (controller.selectedItem.value.repairDurability != null && controller.selectedItem.value.repairDurability != 0)
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0.sp),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              iconShopDurabilityLightPng,
                                              const Padding(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: StyledText(
                                                  '내구도 수리',
                                                  fontWeight: 500,
                                                  fontSize: 14,
                                                  lineHeight: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          StyledText(
                                            '+${formatDecimalPlaces(controller.selectedItem.value.repairDurability!, 0)}',
                                            fontSize: 12,
                                            fontWeight: 500,
                                            color: AppColorData.regular().colorPointPurple,
                                            letterSpacing: -.1,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0.sp),
                                        child: ClipRRect(
                                          child: SizedBox(
                                            height: 11,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: subBg02Color,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(50.sp),
                                                    ),
                                                  ),
                                                ),
                                                LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: AppColorData.regular().colorPointPurple,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(30.sp),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      // 체력

                      Padding(
                        padding: EdgeInsets.only(top: 30.sp, bottom: 120.sp),
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
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 25.sp),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: popupBgColor,
                    shape: CustomRoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.sp), topRight: Radius.circular(15.sp)),
                      leftSide: BorderSide(color: skyBlueColor, width: 2.sp),
                      topLeftCornerSide: BorderSide(color: skyBlueColor, width: 2.sp),
                      rightSide: BorderSide(color: skyBlueColor, width: 2.sp),
                      topRightCornerSide: BorderSide(color: skyBlueColor, width: 2.sp),
                      topSide: BorderSide(color: skyBlueColor, width: 2.sp),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            '${formatDecimalPlaces(controller.selectedItem.value.price.toDouble(), controller.selectedItem.value.tradeSymbol == 'STIK' ? 2 : 0, isAutoDecimal: true)} ${controller.selectedItem.value.tradeSymbol ?? 'TIK'}',
                            fontWeight: 500,
                            fontSize: 22,
                            lineHeight: 24,
                          ),
                          if (controller.selectedItem.value.itemLabel != null)
                            Padding(
                              padding: EdgeInsets.only(top: 5.0.sp),
                              child: StyledText(
                                controller.selectedItem.value.itemLabel! == 'CLOSE_DEADLINE' ? '마감임박' : '품절',
                                fontWeight: 500,
                                fontSize: 14,
                                lineHeight: 16,
                                color: skyBlueColor,
                              ),
                            ),
                        ],
                      ),
                      controller.selectedItem.value.itemLabel != null && controller.selectedItem.value.itemLabel == 'SOLD_OUT'
                          ? InkWell(
                              onTap: () => null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: subBg01Color,
                                  border: Border.all(width: 2.sp, color: deepGrayColor),
                                  borderRadius: BorderRadius.circular(30.sp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                                  child: StyledText(
                                    '구매하기',
                                    fontSize: 18,
                                    lineHeight: 20,
                                    color: deepGrayColor,
                                    letterSpacing: -.1,
                                  ),
                                ),
                              ),
                            )
                          : controller.selectedItem.value.itemCategory == 'DISPOSABLE' && controller.purchaseItemCount < 1
                              ? InkWell(
                                  onTap: () => null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: subBg01Color,
                                      border: Border.all(width: 2.sp, color: deepGrayColor),
                                      borderRadius: BorderRadius.circular(30.sp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                                      child: StyledText(
                                        '구매하기',
                                        fontSize: 18,
                                        lineHeight: 20,
                                        color: deepGrayColor,
                                        letterSpacing: -.1,
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () => controller.onClickPurchaseItem(controller.selectedItem.value.tradeSymbol),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.sp, color: skyBlueColor),
                                      borderRadius: BorderRadius.circular(30.sp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                                      child: const StyledText(
                                        '구매하기',
                                        fontSize: 18,
                                        lineHeight: 20,
                                        letterSpacing: -.1,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
