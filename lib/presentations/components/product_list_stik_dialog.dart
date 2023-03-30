import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_go_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

List<Widget> renderProductStikList(GoWalletController controller) {
  return controller.productList
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
                  StyledText(
                    '${formatDecimalPlaces(product.value.toUiAmount, 0)} ${product.value.toSymbol}',
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
                      onTap: () => controller.purchaseInAppItem(product.value),
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/wallet/ico_product_list_stik.png', width: 14, height: 14),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0.sp),
                              child: StyledText(
                                '${formatDecimalPlaces(product.value.fromUiAmount, 9, isAutoDecimal: true)} ${product.value.fromSymbol}',
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

void showProductStikList(WalletMasterController controller) {
  GoWalletController goWalletController = Get.put(GoWalletController());
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
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.sp, top: 16.sp, right: 24.sp, bottom: 28.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: HiveStore.loadString(key: HiveKey.profileImageUrl.name) != null && HiveStore.loadString(key: HiveKey.profileImageUrl.name) != ''
                                  ? CachedNetworkImageProvider(
                                      HiveStore.loadString(key: HiveKey.profileImageUrl.name)!,
                                    )
                                  : Image.asset(
                                      'assets/images/ic_launcher.png',
                                      width: 30.sp,
                                    ).image,
                              radius: 25,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: StyledText(
                                '보유 중',
                                fontSize: 18,
                                fontWeight: 600,
                                lineHeight: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                StyledText(
                                  formatDecimalPlaces(double.parse(controller.tik.value.uiAmountString!), 0),
                                  fontSize: 16.sp,
                                  fontWeight: 700,
                                  lineHeight: 18.sp,
                                  letterSpacing: -0.5,
                                  color: lightGrayColor,
                                ),
                                StyledText(
                                  ' TIK',
                                  fontSize: 16.sp,
                                  fontWeight: 400,
                                  lineHeight: 18.sp,
                                  letterSpacing: -0.5,
                                  color: lightGrayColor,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.sp),
                              child: Row(
                                children: [
                                  StyledText(
                                    formatDecimalPlaces(double.parse(controller.stik.value.uiAmountString!), 0),
                                    fontSize: 16.sp,
                                    fontWeight: 700,
                                    lineHeight: 18.sp,
                                    letterSpacing: -0.5,
                                    color: lightGrayColor,
                                  ),
                                  StyledText(
                                    ' STIK',
                                    fontSize: 16.sp,
                                    fontWeight: 400,
                                    lineHeight: 18.sp,
                                    letterSpacing: -0.5,
                                    color: lightGrayColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                      ...renderProductStikList(goWalletController),
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
                                      '위에 안내한 금액이 5분간 유지되며 해당 가격으로 거래가 진행됩니다.',
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
                                      '사용되는 TIK의 10%가 교환 수수료로 추가 사용됩니다.',
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
                                      '본 화면 이탈 후 재접근 시 가격이 변경될 수 있습니다.',
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
