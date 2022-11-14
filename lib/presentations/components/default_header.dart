import 'package:flutter/material.dart';
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
      width: double.infinity,
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPrevButtonHide! == false)
            Positioned(
              left: 15,
              child: SizedBox(
                width: 30,
                height: 30,
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
                      'assets/images/icons/icon_chevron_left_black.svg',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          titleWidget ??
              Text(
                titleText ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
          Positioned(
            right: 15,
            child: trailingChild ?? Container(),
          )
        ],
      ),
    );
  }
}
