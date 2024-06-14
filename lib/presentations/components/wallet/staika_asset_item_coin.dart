import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_staika_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/wallet_token_balance_model.dart';
import 'package:gaza_go/theme/theme.g.dart';
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
        color: AppColorData.regular().colorBgTertiary,
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
                  asset.logoUrl != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: asset.logoUrl,
                            width: 40,
                            height: 40,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/images/common/ico_stik.svg',
                        ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0.sp),
                            child: Text(
                              asset.name,
                              style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
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
                                        Text(
                                          formatDecimalPlaces(double.parse(asset.uiAmountString), 4, isAutoDecimal: true, roundType: RoundType.floor),
                                          style: AppTextStyleData.regular().koBodySemiboldXl.copyWith(
                                                color: AppColorData.regular().colorTextPrimary,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 3),
                                          child: Text(
                                            asset.symbol,
                                            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                                  color: AppColorData.regular().colorTextPrimary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${staikaWalletController.currencyString.value} ${formatDecimalPlaces(double.parse(
                                          staikaWalletController.getCurrencyPrice(
                                            staikaWalletController.priceInfoList.firstWhere((priceInfo) => priceInfo.name == asset.name),
                                            double.parse(asset.uiAmountString),
                                          ),
                                        ), staikaWalletController.isKRW.value ? 0 : 2)}',
                                    style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                                          color: AppColorData.regular().colorTextTertiary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                        height: 56.sp,
                        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: AppColorData.regular().colorBgTertiary,
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                buttonText!,
                                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorTextPrimary,
                                    ),
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
