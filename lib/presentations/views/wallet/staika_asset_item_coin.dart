import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class StaikaAssetItemCoin extends StatelessWidget {
  final WalletTokenBalanceModel asset;
  final VoidCallback? onTap;
  final VoidCallback? onTapButton;
  final String? buttonText;
  final bool showPrice;
  const StaikaAssetItemCoin({Key? key, required this.asset, this.onTap, this.onTapButton, this.buttonText, this.showPrice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StaikaWalletController staikaWalletController = Get.find();
    return Ink(
      decoration: BoxDecoration(
        color: subBg02Color,
        border: Border.all(width: 2.sp, color: Colors.black),
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2.sp, 4.sp),
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.sp,
                left: 20.sp,
                right: 20.sp,
                bottom: 30.sp,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 19.sp,
                    foregroundImage: asset.logoUrl != null && asset.logoUrl != ''
                        ? CachedNetworkImageProvider(
                            asset.logoUrl!,
                          )
                        : const Svg('assets/images/wallet/ico_stik.svg') as ImageProvider,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0.sp),
                            child: StyledText(
                              asset.name!,
                              fontSize: 18,
                              lineHeight: 18,
                              fontWeight: 500,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.0.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StyledText(
                                          '${formatDecimalPlaces(double.parse(asset.uiAmountString!), 9, isAutoDecimal: true)}',
                                          fontSize: 18,
                                          lineHeight: 20,
                                          letterSpacing: 0.5,
                                          fontWeight: 700,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 3),
                                          child: StyledText(
                                            asset.symbol!,
                                            fontSize: 18,
                                            lineHeight: 20,
                                            letterSpacing: 0.5,
                                            fontWeight: 400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StyledText(
                                    '${staikaWalletController.currencyString.value} ${formatDecimalPlaces(double.parse(staikaWalletController.getCurrencyPrice(double.parse(asset.uiAmountString!))), staikaWalletController.isKRW.value ? 0 : 2)}',
                                    fontSize: 14,
                                    lineHeight: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: 500,
                                    color: const Color(0xFFA5A5A5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // showPrice
                          //     ? Padding(
                          //         padding: EdgeInsets.only(top: 4.sp),
                          //         child: StyledText(
                          //           '\u2248 \$${asset.amount! / pow(10, asset.decimals!)}',
                          //           fontSize: 14,
                          //           lineHeight: 20,
                          //           letterSpacing: -0.5,
                          //           fontWeight: 500,
                          //         ),
                          //       )
                          //     : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTapButton != null
                ? Padding(
                    padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 11.sp),
                    child: GestureDetector(
                      onTap: onTapButton,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: subBg02Color,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(12.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 2.sp),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (asset.symbol == 'STIK')
                              Padding(
                                padding: EdgeInsets.only(right: 6.0.sp),
                                child: iconOutCoin,
                              ),
                            Center(
                              child: StyledText(
                                buttonText!,
                                color: Colors.white,
                                fontWeight: 600,
                                fontSize: 16,
                                lineHeight: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
