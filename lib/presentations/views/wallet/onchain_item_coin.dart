import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/asset_solana_balance_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class OnChainItemCoin extends StatelessWidget {
  final AssetSolanaBalanceModel asset;
  final VoidCallback? onTapButton;
  final String? buttonText;
  const OnChainItemCoin({Key? key, required this.asset, this.onTapButton, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 12.sp,
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 27.sp,
              left: 18.sp,
              right: 20.sp,
              bottom: 20.sp,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 19.sp,
                  foregroundImage: CachedNetworkImageProvider(
                    asset.logoUrl,
                    headers: imageNetworkHeader,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.sp),
                    child: StyledText(asset.name, fontSize: 18, lineHeight: 18, fontWeight: 500, color: Colors.white),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledText(
                          formatDecimalPlaces(asset.uiAmount, 9, isAutoDecimal: true),
                          fontSize: 18,
                          lineHeight: 20,
                          letterSpacing: 0.5,
                          fontWeight: 700,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: StyledText(
                            asset.symbol,
                            fontSize: 18,
                            lineHeight: 20,
                            letterSpacing: 0.5,
                            fontWeight: 400,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.sp),
                      child: StyledText(
                        '₩ 287,888.000',
                        fontSize: 14,
                        lineHeight: 14,
                        fontWeight: 500,
                        color: Color(0xFFA5A5A5),
                      ),
                    )
                  ],
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
                      child: Center(
                        child: StyledText(
                          buttonText!,
                          color: Colors.white,
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
    );
  }
}
