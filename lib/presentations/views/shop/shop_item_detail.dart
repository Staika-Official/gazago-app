import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ShopItemDetail extends StatelessWidget {
  const ShopItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeMenuController homeMenuController = Get.put(HomeMenuController());
    ShopController controller = Get.find();
    return Scaffold(
      appBar: homeMenuController.appbarList[1],
      backgroundColor: subBg01Color,
      body: Obx(() {
        return SizedBox(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0.sp),
                child: Column(
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
                            Positioned(
                              right: 32.sp,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: getItemGradeColor(controller.selectedItem.value.itemGrade),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5.sp),
                                    bottomLeft: Radius.circular(5.sp),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(1.sp, 2.sp),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 90.sp,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 5.0.sp, horizontal: 10.0.sp),
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
                              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 20.0.sp),
                              child: Obx(
                                () {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 40.0.sp),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(controller.selectedItem.value.itemImageUrl),
                                              width: 150.sp,
                                              fit: BoxFit.fill,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: StyledText(
                                          controller.selectedItem.value.name,
                                          fontSize: 18,
                                          fontWeight: 500,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 5.sp),
                                        decoration: BoxDecoration(
                                          color: subBg01Color,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.sp),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0.sp),
                                          child: FittedBox(
                                            fit: BoxFit.none,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 20.0.sp),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          StyledText(
                                                            controller.selectedItem.value.rewardRate,
                                                            fontSize: 22,
                                                            lineHeight: 26,
                                                            fontWeight: 500,
                                                            color: skyBlueColor,
                                                          ),
                                                          StyledText(
                                                            '%',
                                                            fontSize: 16,
                                                            lineHeight: 24,
                                                            fontWeight: 500,
                                                            color: skyBlueColor,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.0.sp),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 1.0.sp, right: 2.0.sp),
                                                              child: iconGoReward,
                                                            ),
                                                            StyledText(
                                                              'GO 보상율',
                                                              color: deepGrayColor,
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
                                                if (controller.selectedItem.value.itemCategory == 'SHOES')
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          StyledText(
                                                            controller.selectedItem.value.durability,
                                                            fontSize: 22,
                                                            lineHeight: 26,
                                                            fontWeight: 500,
                                                            color: purpleColor,
                                                          ),
                                                          StyledText(
                                                            '%',
                                                            fontSize: 16,
                                                            lineHeight: 24,
                                                            fontWeight: 500,
                                                            color: purpleColor,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.0.sp),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 1.0.sp, right: 5.0.sp),
                                                              child: iconItemAbrasion,
                                                            ),
                                                            StyledText(
                                                              '내구도 감소율',
                                                              color: deepGrayColor,
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
                                                  padding: EdgeInsets.only(left: 20.0.sp),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          StyledText(
                                                            controller.selectedItem.value.staminaReduceRate,
                                                            fontSize: 22,
                                                            lineHeight: 26,
                                                            fontWeight: 500,
                                                            color: lightGreenColor,
                                                          ),
                                                          StyledText(
                                                            '%',
                                                            fontSize: 16,
                                                            lineHeight: 24,
                                                            fontWeight: 500,
                                                            color: lightGreenColor,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.0.sp),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 1.0.sp, right: 2.0.sp),
                                                              child: iconStaminaReduce,
                                                            ),
                                                            StyledText(
                                                              '체력 감소율',
                                                              color: deepGrayColor,
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 30.sp, bottom: 20.sp),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 10.sp),
                                              child: StyledText(
                                                '제품 설명',
                                                color: deepGrayColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 100.sp,
                                              child: ListView(
                                                children: [
                                                  StyledText(
                                                    controller.selectedItem.value.description.toString(),
                                                    color: const Color(0xFFE2E2E2),
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
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
                            '${formatDecimalPlaces(controller.selectedItem.value.price.toDouble(), 0)} TIK',
                            fontWeight: 500,
                            fontSize: 22,
                            lineHeight: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0.sp),
                            child: StyledText(
                              '마감임박',
                              fontWeight: 500,
                              fontSize: 14,
                              lineHeight: 16,
                              color: skyBlueColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => controller.onClickPurchaseItem(),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.sp, color: skyBlueColor),
                            borderRadius: BorderRadius.circular(30.sp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.sp),
                            child: StyledText(
                              '구매하기',
                              fontSize: 18,
                              lineHeight: 20,
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
