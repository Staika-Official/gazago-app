import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

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
                    product.value.name! == 'Taika'
                        ? 'earned_tik'.tr()
                        : 'charged_tik_no_stik_exchange'.tr(),
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

List<Widget> renderMySpendingTokenList(WalletMasterController controller) {
  return controller.spendingTokenUiList
      .asMap()
      .entries
      .map((product) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 4.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText(
                      product.value.name!,
                      fontSize: 16,
                      fontWeight: 400,
                      lineHeight: 20,
                      letterSpacing: -0.1,
                    ),
                    Row(
                      children: [
                        StyledText(
                          formatDecimalPlaces(
                              double.parse(product.value.uiAmountString!),
                              product.value.symbol! == 'TOTAL_TIK' ? 0 : 4,
                              isAutoDecimal: true,
                              roundType: RoundType.floor),
                          fontSize: 14,
                          fontWeight: 700,
                          lineHeight: 20,
                          letterSpacing: -0.1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.0.sp),
                          child: StyledText(
                            product.value.symbol! == 'TOTAL_TIK'
                                ? 'TIK'
                                : product.value.symbol!,
                            fontSize: 14,
                            fontWeight: 400,
                            lineHeight: 20,
                            letterSpacing: -0.1,
                            color: lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                product.value.symbol! == 'TOTAL_TIK'
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.0.sp, bottom: 5.sp),
                        child: Column(
                          children: [...renderMyTikList(controller)],
                        ),
                      )
                    : Container()
              ],
            ),
          ))
      .toList();
}

List<Widget> renderProductStikList(GoWalletController controller,
    WalletMasterController walletMasterController) {
  return controller.productList
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
                    child: product.value!.toTokenSymbol! == 'STIK'
                        ? Image.asset(
                            'assets/images/wallet/ico_product_list_stik.png',
                            width: 20,
                            height: 20)
                        : iconTik,
                  ),
                  StyledText(
                    '${formatDecimalPlaces(product.value!.toTokenSymbol! == 'STIK' ? double.parse(product.value.toUiAmountString!) : productMinusFeePrice(product.value.toUiAmountString!, product.value.uiFeeString!), 0)} ${product.value!.toTokenSymbol!}',
                    fontSize: 18.sp,
                    fontWeight: 700,
                    lineHeight: 18.sp,
                    letterSpacing: -0.5,
                  ),
                ],
              ),
              Material(
                clipBehavior: Clip.none,
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(bottom: 3.sp),
                  child: Ink(
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
                      onTap: () => controller.checkShortBalance(product.value),
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.sp, vertical: 15.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            product.value!.fromTokenSymbol! == 'STIK'
                                ? Image.asset(
                                    'assets/images/wallet/ico_product_list_stik.png',
                                    width: 14,
                                    height: 14)
                                : iconTikSmall,
                            Padding(
                              padding: EdgeInsets.only(left: 5.0.sp),
                              child: StyledText(
                                '${formatDecimalPlaces(product.value!.fromTokenSymbol! == 'STIK' ? double.parse(product.value!.fromUiAmountString!) : productSumFeePrice(product.value!.fromUiAmountString!, product.value!.uiFeeString!), 4, isAutoDecimal: true)} ${product.value.fromTokenSymbol}',
                                fontSize: 14.sp,
                                fontWeight: 500,
                                lineHeight: 16.sp,
                                letterSpacing: -.1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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

void showProductStikList(String assetsName) {
  WalletMasterController controller = Get.find();
  GoWalletController goWalletController = Get.put(GoWalletController());
  Get.dialog(
    barrierDismissible: false,
    useSafeArea: false,
    Dialog(
      insetPadding: EdgeInsets.zero,
      child: Obx(() {
        return DefaultContainer(
          backgroundColor: subBg01Color,

          titleWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0.sp, bottom: 5.sp),
                child: StyledText(
                  'exchange_to_stik_or_tik'
                      .tr(args: [assetsName == 'TAIKA' ? 'STIK' : 'TIK']),
                  fontSize: 18,
                  lineHeight: 18,
                  fontWeight: 500,
                  letterSpacing: -0.02,
                  color: Colors.white,
                ),
              ),
              StyledText(
                '1 STIK = ₩ ${formatDecimalPlaces(controller.stikPriceInfoKRW.value.price!, 0)} / ${formatDate(controller.stikPriceInfoKRW.value.lastUpdated)} (CoinMarket Cap)',
                fontSize: 10,
                lineHeight: 14,
                fontWeight: 500,
                color: deepGrayColor,
                letterSpacing: -0.02,
              ),
            ],
          ),
          // titleText: 'exchange_to_tik'.tr(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 30.0.sp, bottom: 10.sp, left: 20.sp, right: 20.sp),
                child: StyledText(
                  'current_assets'.tr(),
                  fontSize: 16,
                  fontWeight: 600,
                  lineHeight: 20,
                  textAlign: TextAlign.start,
                ),
              ),
              ...renderMySpendingTokenList(controller),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  thickness: 6,
                  color: popupBgColor.withOpacity(0.3),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      ...renderProductStikList(goWalletController, controller),
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
                                  child: StyledText(
                                    '1 STIK = ₩ ${formatDecimalPlaces(controller.stikPriceInfoKRW.value.price!, 0)} / ${formatDate(controller.stikPriceInfoKRW.value.lastUpdated)} (CoinMarket Cap)',
                                    fontSize: 10,
                                    lineHeight: 14,
                                    fontWeight: 500,
                                    color: deepGrayColor,
                                    letterSpacing: -0.02,
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
                                      'price_maintained_for_duration'.tr(),
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
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
                                      'price_may_change'.tr(),
                                      fontSize: 10,
                                      lineHeight: 14,
                                      fontWeight: 500,
                                      color: deepGrayColor,
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
