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
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

List<Widget> renderProductList(WalletMasterController controller) {
  return controller.inAppProducts
      .asMap()
      .entries
      .map(
        (product) => Padding(
          padding: EdgeInsets.only(
              left: 25.sp, top: 17.sp, right: 17.sp, bottom: 17.sp),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: StyledText(
                            'popularity'.tr(),
                            fontSize: 10,
                            lineHeight: 10,
                            fontWeight: 800,
                            color: skyBlueColor,
                          ),
                        ),
                      Row(
                        children: [
                          StyledText(
                            formatDecimalPlaces(
                                controller.getProductPrice(product.value.id) *
                                    0.7,
                                0),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.sp, vertical: 15.sp),
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
                      margin:
                          EdgeInsets.only(top: 5.sp, left: 6.sp, right: 6.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    StyledText(
                      product.value.name! == 'Taika'
                          ? 'earned_tik'.tr()
                          : 'charged_tik'.tr(),
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
                      formatDecimalPlaces(
                          double.parse(product.value.uiAmountString!), 0),
                      fontSize: 12,
                      fontWeight: 700,
                      lineHeight: 20,
                      letterSpacing: -0.1,
                      color: lightGrayColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0.sp),
                      child: const StyledText(
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
          titleText: 'charge_tik'.tr(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24.sp, top: 16.sp, right: 24.sp, bottom: 16.sp),
                    child: StyledText(
                      'current_assets'.tr(),
                      fontSize: 16,
                      fontWeight: 600,
                      lineHeight: 20,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24.sp, right: 24.sp, bottom: 16.sp),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const StyledText(
                                'Taika',
                                fontSize: 16,
                                fontWeight: 400,
                                lineHeight: 20,
                              ),
                              Row(
                                children: [
                                  StyledText(
                                    formatDecimalPlaces(
                                        double.parse(controller
                                            .tik.value.uiAmountString!),
                                        0),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: StyledText(
                                'usage_guide'.tr(),
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
                                    TextSpan(
                                      text: 'charged_tik_non_exchangeable'.tr(),
                                      children: [
                                        TextSpan(
                                          text: 'no_voucher_stik_exchange'.tr(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: lightGrayColor),
                                        ),
                                        TextSpan(
                                          text: 'non_refundable_tik'.tr(),
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
                                  Expanded(
                                    child: StyledText(
                                      'used_tik_non_refundable'.tr(),
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
                                  Expanded(
                                    child: StyledText(
                                      'price_includes_vat'.tr(),
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
                                      'minor_payment_cancellation'.tr(),
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
                                          ? 'ios_tik_refund_apple'.tr()
                                          : 'android_tik_refund_playstore'.tr(),
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
                                          ? 'ios_tik_check_location'.tr()
                                          : 'android_tik_check_location'.tr(),
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
