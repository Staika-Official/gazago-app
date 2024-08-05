import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class DefaultHeader extends StatelessWidget {
  final bool? isLeadingShow;
  final bool? isPrevButtonHide;
  final Widget? trailingChild;
  final String? titleText;
  final Widget? titleWidget;
  final VoidCallback? onBackButtonTap;

  const DefaultHeader({
    super.key,
    this.isPrevButtonHide,
    this.isLeadingShow,
    this.trailingChild,
    this.titleText,
    this.titleWidget,
    this.onBackButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity.sp,
      height: context.height.sp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPrevButtonHide! == false)
            Positioned(
              left: 15.sp,
              child: Container(
                width: 24,
                padding: EdgeInsets.zero,
                child: IconButton(
                  onPressed: () async {
                    Get.back();
                    if(onBackButtonTap != null) onBackButtonTap!();
                  } ,
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  splashRadius: 24.sp,
                  icon: iconHeaderBack,
                ),
              ),
            ),
          titleWidget ??
              Text(
                titleText ?? '',
                style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
              ),
          Positioned(
            right: 15.sp,
            child: trailingChild ?? Container(),
          )
        ],
      ),
    );
  }
}
