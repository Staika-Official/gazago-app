import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

List<Widget> renderProductList(WalletMasterController controller) {
  return controller.inAppProducts
      .asMap()
      .entries
      .map(
        (product) => Padding(
          padding: EdgeInsets.only(left: 25.sp, top: 17.sp, right: 17.sp, bottom: 17.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.sp),
                    child: iconTik,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ([2, 4, 5].any((element) => element == product.key))
                        const Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: StyledText(
                            '인기',
                            fontSize: 10,
                            lineHeight: 10,
                            fontWeight: 800,
                            color: skyBlueColor,
                          ),
                        ),
                      Row(
                        children: [
                          StyledText(
                            formatDecimalPlaces(controller.getProductPrice(product.value.id) * 0.7, 0),
                            fontSize: 18.sp,
                            fontWeight: 700,
                            lineHeight: 18.sp,
                            letterSpacing: -0.5,
                          ),
                          StyledText(
                            ' TIK',
                            fontSize: 18.sp,
                            fontWeight: 400,
                            lineHeight: 18.sp,
                            letterSpacing: -0.5,
                          ),
                          if (product.key > 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  StyledText(
                                    '+ ${formatDecimalPlaces(controller.getProductPrice(product.value.id) * (product.key < 4 ? 0.05 : 0.1), 0)}',
                                    fontSize: 12.sp,
                                    fontWeight: 700,
                                    lineHeight: 16.sp,
                                    color: bonusTikColor,
                                  ),
                                  StyledText(
                                    ' TIK',
                                    fontSize: 12.sp,
                                    fontWeight: 500,
                                    lineHeight: 16.sp,
                                    color: bonusTikColor,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Material(
                clipBehavior: Clip.none,
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(bottom: 3.sp),
                  child: Ink(
                    width: 125.sp,
                    decoration: BoxDecoration(
                      color: subBg02Color,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 3.sp),
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () => controller.purchaseInAppItem(product.value),
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 15.sp),
                        child: FittedBox(
                          child: StyledText(
                            '${product.value.currencySymbol}${formatDecimalPlaces(product.value.rawPrice, 2, isAutoDecimal: true)}',
                            fontSize: 14.sp,
                            fontWeight: 500,
                            lineHeight: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
      .toList();
}

void showProductList() {
  List<Widget> renderMyTikList(WalletMasterController controller) {
    return controller.allTikUiList
        .asMap()
        .entries
        .map((product) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 2,
                      margin: EdgeInsets.only(top: 5.sp, left: 6.sp, right: 6.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    StyledText(
                      product.value.name! == 'Taika' ? '활동으로 받은 TIK' : '충전한 TIK',
                      fontSize: 12,
                      fontWeight: 400,
                      lineHeight: 18,
                      letterSpacing: -0.1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    StyledText(
                      '${formatDecimalPlaces(double.parse(product.value.uiAmountString!), 0)}',
                      fontSize: 12,
                      fontWeight: 700,
                      lineHeight: 20,
                      letterSpacing: -0.1,
                      color: lightGrayColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0.sp),
                      child: StyledText(
                        'TIK',
                        fontSize: 12,
                        fontWeight: 400,
                        lineHeight: 20,
                        letterSpacing: -0.1,
                        color: lightGrayColor,
                      ),
                    ),
                  ],
                ),
              ],
            ))
        .toList();
  }

  WalletMasterController controller = Get.find();
  Get.dialog(
    barrierDismissible: false,
    useSafeArea: false,
    Dialog(
      insetPadding: EdgeInsets.zero,
      child: Obx(() {
        return DefaultContainer(
          backgroundColor: subBg01Color,
          titleText: 'TIK 충전하기',
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.sp, top: 16.sp, right: 24.sp, bottom: 16.sp),
                    child: StyledText(
                      '현재 보유 자산',
                      fontSize: 16,
                      fontWeight: 600,
                      lineHeight: 20,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.sp, right: 24.sp, bottom: 16.sp),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyledText(
                                'Taika',
                                fontSize: 16,
                                fontWeight: 400,
                                lineHeight: 20,
                              ),
                              Row(
                                children: [
                                  StyledText(
                                    formatDecimalPlaces(double.parse(controller.tik.value.uiAmountString!), 0),
                                    fontSize: 14.sp,
                                    fontWeight: 700,
                                    lineHeight: 20.sp,
                                    letterSpacing: -0.5,
                                  ),
                                  StyledText(
                                    ' TIK',
                                    fontSize: 14.sp,
                                    fontWeight: 400,
                                    lineHeight: 20.sp,
                                    letterSpacing: -0.5,
                                    color: lightGrayColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...renderMyTikList(controller),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 6,
                    color: popupBgColor.withOpacity(0.3),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      ...renderProductList(controller),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 9),
                              child: StyledText(
                                '이용안내',
                                fontSize: 14,
                                lineHeight: 18,
                                fontWeight: 500,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2,
                                  height: 2,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: lightGrayColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      height: 14.sp / 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: deepGrayColor,
                                      letterSpacing: -.1,
                                    ),
                                    const TextSpan(
                                      text: '충전한 TIK은',
                                      children: [
                                        TextSpan(
                                          text: ' 상품권, STIK 교환은 불가',
                                          style: TextStyle(fontWeight: FontWeight.w700, color: lightGrayColor),
                                        ),
                                        TextSpan(
                                          text: '합니다.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2,
                                    height: 2,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const Expanded(
                                    child: StyledText(
                                      '이미 사용한 TIK은 환불할 수 없으며, 이미 사용한 TIK을 환불받은 경우 사전통지 없이 회원이 보유한 TIK에서 환불받은 금액을 회수할 수 있습니다.',
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      letterSpacing: -.1,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2,
                                    height: 2,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const Expanded(
                                    child: StyledText(
                                      '결제된 가격은 부가가치세가 포함된 가격입니다.',
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      color: deepGrayColor,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2,
                                    height: 2,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const Expanded(
                                    child: StyledText(
                                      '법정대리인의 동의 없는 미성년자의 결제는 취소될 수 있습니다.',
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      color: deepGrayColor,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2,
                                    height: 2,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Expanded(
                                    child: StyledText(
                                      Platform.isIOS ? 'iOS앱에서 충전한 TIK은 Apple 고객센터에서 환불 가능합니다.' : '안드로이드 앱에서 충전한 TIK은 Play 스토어고객센터에서 환불 가능합니다.',
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      color: deepGrayColor,
                                      letterSpacing: -.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 2,
                                    height: 2,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Expanded(
                                    child: StyledText(
                                      Platform.isIOS
                                          ? 'iOS앱에서 충전한 TIK은 모바일 기기에서는 \‘OS설정 > 계정\’에서, 데스크탑에서는 \‘iTunes > 계정 > 나의 계정보기 > 구입내역\' 메뉴에서 확인 가능합니다.'
                                          : '안드로이드 앱에서 충전한 TIK은 모바일 기기에서는 \‘Play 스토어 > 프로필 > 결제 및 정기 결제 > 예산 및 내역\’에서, 데스크탑에서는 \‘play.google.com > 프로필 > 결제 및 정기 결제 > 예산 및 주문 내역\’ 메뉴에서 확인 가능합니다.',
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      color: deepGrayColor,
                                      letterSpacing: -.1,
                                    ),
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
            ],
          ),
        );
      }),
    ),
  );

  if (controller.storeUnavailable.value) {
    showStoreNotAvailableAlert();
  }
}
