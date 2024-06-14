import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/wallet_assets_button_model.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';

class GoAssetItemCoin extends StatelessWidget {
  final AssetTokenBalanceModel asset;
  final bool showPrice;
  final List<WalletAssetsButtonModel> actions;
  final VoidCallback onTap;
  const GoAssetItemCoin({Key? key, required this.asset, required this.onTap, required this.actions, this.showPrice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: EdgeInsets.only(top: 24.sp, bottom: 16.sp, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 16.sp,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.sp,
                          foregroundImage: asset.logoUrl != null && asset.logoUrl != ''
                              ? CachedNetworkImageProvider(
                                  asset.logoUrl!,
                                  headers: imageNetworkHeader,
                                )
                              : const Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.sp),
                          child: Text(
                            asset.name!,
                            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0.sp),
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    formatDecimalPlaces(double.parse(asset.uiAmountString!), asset.symbol == 'STIK' ? 4 : asset.decimals!, isAutoDecimal: true, roundType: RoundType.floor),
                                    style: AppTextStyleData.regular().koBodySemiboldXl.copyWith(
                                          color: AppColorData.regular().colorTextPrimary,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      asset.symbol == 'TOTAL_TIK' ? 'TIK' : asset.symbol!,
                                      style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                            color: AppColorData.regular().colorTextPrimary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              showPrice
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.sp),
                                      child: StyledText(
                                        '\u2248 \$${asset.amount! / pow(10, asset.decimals!)}',
                                        fontSize: 14,
                                        lineHeight: 20,
                                        letterSpacing: -0.5,
                                        fontWeight: 500,
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.only(left: 4.sp, top: 2.sp),
                                child: iconChevronRightWhite,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var item in actions.asMap().entries) ...[
                    if (item.key > 0)
                      SizedBox(
                        height: 12,
                      ),
                    GestureDetector(
                      onTap: () => item.value.onTapButton!(),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 12.sp),
                        decoration: BoxDecoration(
                          color: AppColorData.regular().colorBgTertiary,
                          border: Border.all(
                            width: 2,
                            color: AppColorData.regular().colorBorderBlack,
                          ),
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: FittedBox(
                          child: Text(
                            item.value.buttonText,
                            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
