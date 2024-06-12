import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/theme/theme.g.dart';

class NftAssetItem extends StatelessWidget {
  final VoidCallback onTap;
  const NftAssetItem({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.sp, left: 21.sp, right: 21.sp),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0.sp),
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
                      bottom: 16.sp,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.5.sp,
                              foregroundImage: sp.Svg('assets/images/icons/icon_nft.svg', source: sp.SvgSource.asset) as ImageProvider,
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.sp),
                              child: Text(
                                'NFT',
                                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                      color: AppColorData.regular().colorTextPrimary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onTap,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0.sp),
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
                                  '목록보기',
                                  style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                        color: AppColorData.regular().colorTextPrimary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
