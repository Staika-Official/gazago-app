import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

List<Widget> renderProductList(WalletMasterController controller) {
  return controller.inAppProducts
      .map(
        (product) => Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
          child: Column(
            children: [
              Row(
                children: [
                  iconActivityStoryTaika,
                  StyledText(
                    formatDecimalPlaces(product.rawPrice * 0.7, 0),
                    fontSize: 16,
                    lineHeight: 20,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      StyledText(
                        '결제 금액 ',
                        fontSize: 16,
                        lineHeight: 20,
                      ),
                      StyledText(
                        product.price,
                        fontSize: 16,
                        lineHeight: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                    child: GazagoButton(buttonText: '구매하기', onTap: () => controller.purchaseInAppItem(product)),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
      .toList();
}

void showProductList(WalletMasterController controller) {
  Get.dialog(
    useSafeArea: true,
    barrierDismissible: false,
    Dialog(
      insetPadding: EdgeInsets.zero,
      child: Obx(() {
        return Container(
          width: double.infinity,
          color: popupBgColor,
          child: controller.showPendingPurchaseUI.value
              ? Center(
                  child: WillPopScope(
                    onWillPop: () async => false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StyledText('결제요청을 처리중입니다.'),
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: StyledText(
                            'TIK 충전하기',
                            fontSize: 20,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          right: 14,
                          top: 14,
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: iconCloseWhite,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: controller.storeUnavailable.value
                              ? SizedBox(
                                  width: double.infinity,
                                  child: StyledText(
                                    '상점과 연결에 실패했습니다.',
                                    fontSize: 16,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Column(
                                  children: [
                                    ...renderProductList(controller),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      }),
    ),
  );
}
