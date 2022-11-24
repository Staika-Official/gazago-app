import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/asset_token_balance_ui_model.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class AssetItemCoin extends StatelessWidget {
  final AssetTokenBalanceUiModel asset;
  final VoidCallback onTap;
  final VoidCallback? onTapButton;
  final String? buttonText;
  final bool showPrice;
  const AssetItemCoin({Key? key, required this.asset, required this.onTap, this.onTapButton, this.buttonText, this.showPrice = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Color(0xff2a2b33),
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
                top: 22.sp,
                left: 16.sp,
                right: 16.sp,
                bottom: 22.sp,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 19.sp,
                    foregroundImage: asset.meta?.logoUrl != ''
                        ? CachedNetworkImageProvider(
                            asset.meta!.logoUrl,
                          )
                        : Svg('assets/images/common/ico_token_tik.svg') as ImageProvider,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: StyledText(
                        asset.meta!.name,
                        fontSize: 18,
                        lineHeight: 18,
                        fontWeight: 500,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StyledText(
                            formatDecimalPlaces(double.parse(asset.uiAmountString!), asset.decimals!),
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: 0.5,
                            fontWeight: 600,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: StyledText(
                              asset.meta!.symbol,
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
                    ],
                  )
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
                          color: Color(0xff0EE6F3),
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(12.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 2.sp),
                            ),
                          ],
                        ),
                        child: Center(
                          child: StyledText(
                            buttonText!,
                            color: Colors.black,
                            fontWeight: 600,
                            fontSize: 16,
                            lineHeight: 16,
                          ),
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
