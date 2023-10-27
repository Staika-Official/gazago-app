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
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';



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
        child: Padding(
          padding: EdgeInsets.only(bottom:8.0.sp),
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 22.sp,
                      bottom: 19.sp,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 19.sp,
                              foregroundImage: asset.logoUrl != null && asset.logoUrl != ''
                                  ? CachedNetworkImageProvider(
                                asset.logoUrl!,
                                headers: imageNetworkHeader,
                              )
                                  : const Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:10.0.sp),
                              child: StyledText(asset.name!, fontSize: 18, lineHeight: 20, fontWeight: 500, letterSpacing: -.1, ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left:10.0.sp),
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
                                      StyledText(
                                        formatDecimalPlaces(double.parse(asset.uiAmountString!), asset.symbol == 'STIK' ? 4 : asset.decimals!, isAutoDecimal: true, roundType: RoundType.floor),
                                        fontSize: 18,
                                        lineHeight: 20,
                                        letterSpacing: 0.5,
                                        fontWeight: 700,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: StyledText(
                                          asset.symbol == 'TOTAL_TIK' ? 'TIK' : asset.symbol!,
                                          fontSize: 18,
                                          lineHeight: 20,
                                          letterSpacing: 0.5,
                                          fontWeight: 400,
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
                                    padding: EdgeInsets.only(left:10.0.sp, right: 5.sp),
                                    child: iconArrowRightTriangle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:16.0.sp),
                    child: Divider(
                      height: 1,
                      thickness: 2.0.sp,
                      color: subBg01Color,
                    ),
                  ),
                  ...actions.map((item) =>
                      GestureDetector(
                        onTap: () => item.onTapButton!(),
                        child: Padding(
                          padding: EdgeInsets.only(bottom:8.0.sp),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
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
                            child:  StyledText(
                              item.buttonText,
                              color: Colors.white,
                              fontWeight: 600,
                              fontSize: 16,
                              lineHeight: 16,
                            ),
                          ),
                        ),
                      )
                  ).toList(),


                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
}
