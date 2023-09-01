import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DefaultHeader extends StatelessWidget {
  final bool? isLeadingShow;
  final bool? isPrevButtonHide;
  final Widget? trailingChild;
  final String? titleText;
  final Widget? titleWidget;
  final VoidCallback? onBackButtonTap;

  const DefaultHeader({
    Key? key,
    this.isPrevButtonHide,
    this.isLeadingShow,
    this.trailingChild,
    this.titleText,
    this.titleWidget,
    this.onBackButtonTap,
  }) : super(key: key);

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
              child: SizedBox(
                width: 30.sp,
                height: 30.sp,
                child: Visibility(
                  visible: isLeadingShow ?? true,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    onTap: onBackButtonTap ??
                        () {
                          Get.back();
                        },
                    child: SvgPicture.asset(
                      fit: BoxFit.contain,
                      'assets/images/icons/icon_chevron_left_white.svg',
                    ),
                  ),
                ),
              ),
            ),
          titleWidget ??
              Text(
                titleText ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  height: 1,
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
